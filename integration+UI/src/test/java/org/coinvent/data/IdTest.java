package org.coinvent.data;

import static org.junit.Assert.*;

import org.junit.Test;

public class IdTest {

	@Test
	public void testId() {
		Id id = new Id(KKind.User, "daniel");
		assert id.getName().equals("daniel");
		
		Id id2 = new Id(id.toString());
		assert id2.equals(id);
		
		assert id2.getName().equals("daniel");
	}

	@Test
	public void testGetName() {
		Id id = new Id(KKind.User, "daniel");
		assert id.getName().equals("daniel");
		
		Id id2 = new Id(KKind.User, "_King Richard III!");
		assert id2.getName().equals("_King Richard III!");
		System.out.println(id2);
	}


}
