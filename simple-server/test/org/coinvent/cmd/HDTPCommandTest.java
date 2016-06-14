package org.coinvent.cmd;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;

import org.junit.After;
import org.junit.Test;

import com.winterwell.utils.Proc;
import com.winterwell.utils.io.FileUtils;

public class HDTPCommandTest {

	private HDTPAmalCommand cmd;


	@Test
	public void testClose() throws IOException {
		File f1 = File.createTempFile("test", ".dol");
		File f2 = File.createTempFile("test", ".dol");
		
		FileUtils.write(f1, "spec Boat = sorts BodyofWater, Person, Boat; preds is_navigated_by:  Person * Boat; is_located_on: Boat * BodyofWater; meansofTransportation: Boat; ops boat: Boat; bodyofwater: BodyofWater; person: Person; . is_located_on(boat,bodyofwater);. is_navigated_by(person,boat); . meansofTransportation(boat); end");
		FileUtils.write(f2, "spec House = sorts Plot, Person, House; preds is_inhabited_by:  Person * House; is_located_on: House * Plot; servesasResidence: House; ops house: House; plot: Plot; person: Person; . is_located_on(house,plot); . is_inhabited_by(person,house); . servesasResidence(house); end");
		
		cmd = new HDTPAmalCommand(HDTPAmalCommand.CMD.HDTP,f1, f2,"","");
		
		cmd.run();
		
		String out = cmd.getOutput();
		System.out.println("Output: "+out);
		assert ! out.isEmpty();
		
		int pid = cmd.getProc().getProcessId();
		
		{
			Proc info = new Proc("ps -p "+pid+" -o command");
			info.start();
			info.waitFor();
			String psInfoOut = info.getOutput();
			info.close();
			assert psInfoOut.contains("tmp") : psInfoOut;
		}
		
		cmd.close();
		
		{
			Proc info = new Proc("ps -p "+pid+" -o command");
			info.start();
			info.waitFor();
			String psInfoOut = info.getOutput();
			info.close();
			assert ! psInfoOut.contains("tmp") : psInfoOut;
		}
		
		try {
			cmd.next();
			assert false;
		} catch(Exception ex) {
			// :)
		}
	}

	@Test
	public void testRunNext() throws IOException {
		File f1 = File.createTempFile("test", ".dol");
		File f2 = File.createTempFile("test", ".dol");
		
		FileUtils.write(f1, "spec Boat = sorts BodyofWater, Person, Boat; preds is_navigated_by:  Person * Boat; is_located_on: Boat * BodyofWater; meansofTransportation: Boat; ops boat: Boat; bodyofwater: BodyofWater; person: Person; . is_located_on(boat,bodyofwater);. is_navigated_by(person,boat); . meansofTransportation(boat); end");
		FileUtils.write(f2, "spec House = sorts Plot, Person, House; preds is_inhabited_by:  Person * House; is_located_on: House * Plot; servesasResidence: House; ops house: House; plot: Plot; person: Person; . is_located_on(house,plot); . is_inhabited_by(person,house); . servesasResidence(house); end");
		
		cmd = new HDTPAmalCommand(HDTPAmalCommand.CMD.HDTP,f1, f2,"","");
		
		cmd.run();
		
		String out = cmd.getOutput().trim();
		System.out.println("Output: "+out);
		assert ! out.isEmpty();
		
		cmd.next();
		cmd.next();
		
		String out2 = cmd.getOutput().trim();
		assert ! out2.isEmpty();
		System.out.println("Output2: ***"+out2+"***");
		assert ! out.equals(out2);
		assert ! out.contains(out2);
	}


	@After
	public void cleanup() {
		if (cmd!=null) cmd.close();
	}
}
