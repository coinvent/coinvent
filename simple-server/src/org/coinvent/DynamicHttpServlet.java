package org.coinvent;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import winterwell.utils.reporting.Log;
import winterwell.web.WebEx;
import winterwell.web.app.FileServlet;
import winterwell.web.app.WebRequest;

import com.winterwell.utils.web.WebUtils2;

/**
 * Route requests to dynamically created {@link AServlet} objects.
 * This maps the calling path onto Java sub-packages.
 * E.g. if we have a servlet this-package/foo/BarServlet.java,
 * then the url "/foo/bar/snafu" will go to this servlet. 
 * 
 * @author Daniel
 *
 */
public class DynamicHttpServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * e.g. "robots.txt" -> your robots.txt file
	 */
	private final Map<String,File> specialStaticFiles = new HashMap<String, File>();
	
	/**
	 * Over-ride normal servlet routing for a specific file, e.g. robots.txt
	 * @param path 
	 * @param file
	 */
	public void putSpecialStaticFile(String path, File file) {
		specialStaticFiles.put(path, file);
	}
	
	/**
	 * Forward to doPost(), so we handle get and post the same way.
	 */
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
	
	public static final String SPECIAL_STATIC_ERROR_404 = "404.html";

	private static final String BASE_PACKAGE_FOR_SERVLETS = DynamicHttpServlet.class.getPackage().getName();
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String path = req.getRequestURI();
		
		// Special-case static file? E.g. robots
		File file = specialStaticFiles.get(path);
		if (file!=null) {
			Log.d("req", path);
			FileServlet.serveFile(file, new WebRequest(null, req, resp));
			return;
		}
		// Plugin
		try {
			// fetch
			IServlet servlet = getServlet(path);
			// process
			WebRequest webRequest = new WebRequest(servlet, req, resp);
			Log.d("req", webRequest);	
			
			// Support cross-browser requests for all servlets!
			WebUtils2.CORS(webRequest, true);

			servlet.doPost(webRequest);
			
			// Error handling
		} catch(WebEx e) {
			if (e.code == 404) {
				// Just log it
				Log.w("404", path);				
				// Do we have a special 404 page?
				file = specialStaticFiles.get(SPECIAL_STATIC_ERROR_404);
				if (file!=null && file.exists()) {
					FileServlet.serveFile(file, new WebRequest(null, req, resp));
					return;
				}
			}
			processError(e, resp);			
		} catch (Throwable e) {
			processError(e, resp);			
		} 
	}
	
	@Override
	protected void doPut(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		super.doPost(req, resp);
	}

	private void processError(Throwable e, HttpServletResponse resp) {
		int code;
		String msg;
		if (e instanceof WebEx) {
			code = ((WebEx)e).code;
			msg = e.getMessage();
		} else {
			code = 500;
			msg = e.toString();
			// probably a bug -- log it
			Log.e("http:"+code, e);
		}
		WebUtils2.sendError(code, msg, resp);
	}

	Map<String,Class> path2servletClass = new HashMap();
	
	/**
	 * Map path to class, looking in {@link #BASE_PACKAGE_FOR_SERVLETS} -- which is this package.
	 * @param path
	 * @return
	 * @throws Exception
	 */
	IServlet getServlet(String path) throws Exception {
		Class sc = path2servletClass.get(path);
		if (sc!=null) return (IServlet) sc.newInstance();
		String[] bits = path.split("/");
		String name = BASE_PACKAGE_FOR_SERVLETS;
		for (String bit : bits) {
			if (bit.isEmpty()) continue;
			try {
				String klassName = bit;
				// chop off any .html part
				int i = klassName.lastIndexOf('.');
				// pop last type
				if (i != -1) klassName = klassName.substring(0, i);
				String cname = name+"."+Character.toUpperCase(klassName.charAt(0))
								+(klassName.length()>1? klassName.substring(1) : "")+"Servlet";
				sc = Class.forName(cname);				
				path2servletClass.put(name, sc);
				return (IServlet) sc.newInstance();
			} catch (Throwable ex) {
				// not that then
			}	
			name += "."+bit;
		}
		// fail -- no such servlet
		throw new WebEx.E404(path);
	}
	
}
