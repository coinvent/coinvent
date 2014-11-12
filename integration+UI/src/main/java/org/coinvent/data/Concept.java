package org.coinvent.data;

import java.io.File;

import org.coinvent.Coinvent;
import org.coinvent.web.FileServlet;

import com.winterwell.utils.io.FileUtils;

import winterwell.utils.StrUtils;
import winterwell.utils.web.WebUtils;
import winterwell.web.FakeBrowser;

public class Concept {

	public String getName() {
		return name;
	}
	String name;
	public Id oxid;
	public Id xid;
	public String format;
	private String url;
	public String getUrl() {
		return url;
	}
	private String text;

	public String getText() {
		if (text==null) {
			if (url==null) return null;
			if (WebUtils.RELATIVE_URL_REGEX.matcher(url).matches()) {
				// lookup the file
				File f = new File(FileServlet.BASE, url);
				text = FileUtils.read(f);
			} else {
				FakeBrowser fb = new FakeBrowser();
				text = fb.getPage(url);
			}
		}
		return text;
	}
	@Override
	public String toString() {
		return "Concept [xid=" + xid + ", lang=" + format + ", iri=" + url
				+ ", contents=" + text + "]";
	}

	public Concept() {		
	}
	
	public Concept(String contents) {
		this.oxid = new Id(KKind.User, "unknown");
		this.xid = getId(oxid, StrUtils.md5(contents));
		setContents(contents);
	}
	
	public Concept(User owner, Id concept) {
		this.xid = concept;
		this.oxid = owner.getId();
	}

	public static Id getId(Id user, String conceptName) {
		return new Id(user, KKind.Concept, conceptName);
	}
	
	public void setContents(String contents) {
		this.text = contents;
	}
	public void setUrl(String url) {
		assert ! url.matches(".*file/+file.*") : url;
		assert url.contains("file") : url;
		this.url = url;
	}

}
