package org.coinvent.impl.oracle;

import java.io.File;

import org.coinvent.data.BlendDiagram;
import org.coinvent.data.Concept;
import org.coinvent.data.DataLayerFactory;
import org.coinvent.data.FileDataLayer;
import org.coinvent.data.IJob;
import org.coinvent.data.Id;
import org.coinvent.data.Job;
import org.coinvent.data.KKind;
import org.coinvent.data.Mapping;
import org.coinvent.web.FileServlet;

import winterwell.utils.containers.ArrayMap;

import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.threads.ATask.QStatus;

public class HouseBoatOracle {

	public static void main(String[] args) {
		FileDataLayer dataLayer = DataLayerFactory.get();
		// Base
		Id oracle = new Id(KKind.User, "oracle");
		{
			Job job = (org.coinvent.data.Job) dataLayer.getJob(new Id(oracle, KKind.Job,		
					"b209ddc5cacc0c5541415c85b8752cb5"));
			BlendDiagram bd = job.getDiagram();
			BlendDiagram based = new BlendDiagram(bd);
			based.base = new Concept(FileUtils.read(new File(FileServlet.BASE, "test/houseboat_base.owl")));
			assert based.input1.getText().contains("House");
			based.base_input1 = new Mapping(new ArrayMap(
						"Agent","Person","Object","House","Site","Plot"));
			based.base_input2 = new Mapping(new ArrayMap(
					"Agent","Person","Object","Boat","Site","BodyOfWater"));    
			job.setResult(based);
			job.setStatus(QStatus.DONE);
			dataLayer.saveJob(job);
		}		
		// Blend
		{
			Job job = (org.coinvent.data.Job) dataLayer.getJob(new Id(oracle, KKind.Job,		
					"8907ebdcc4849ccd808e4e562686f963"));
			BlendDiagram bd = job.getDiagram();
			BlendDiagram based = new BlendDiagram(bd);
			based.blend = new Concept(FileUtils.read(new File(FileServlet.BASE, "test/houseboat_blend.owl")));
			based.input1_blend = new Mapping(new ArrayMap(
						"House","HouseBoat","Plot","BodyOfWater"));
			based.input2_blend = new Mapping(new ArrayMap(
					"Boat","HouseBoat"));    
			job.setResult(based);
			job.setStatus(QStatus.DONE);
			dataLayer.saveJob(job);
		}
		
//		with Object |-> HouseBoat, Site |-> BodyOfWater, Agent |-> Person

	}
}
