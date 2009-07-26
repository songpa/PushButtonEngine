/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 * 
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.engine.unitTests
{
   import com.pblabs.engine.entity.IEntity;
   import com.pblabs.engine.entity.PropertyReference;
   import com.pblabs.engine.core.TemplateManager;
   import com.pblabs.engine.core.NameManager;
   import com.pblabs.engine.debug.Logger;
   import com.pblabs.engine.unitTestHelper.TestComponentA;
   import com.pblabs.engine.unitTestHelper.TestComponentB;
   
   import flash.events.Event;
   
   import net.digitalprimates.fluint.tests.TestCase;
   
   /**
    * @private
    */
   public class LevelTests extends TestCase
   {
      public function testLevelLoading():void
      {
         Logger.PrintHeader(null, "Running Level Loading and Instantiating Test");
         
         TemplateManager.Instance.addEventListener(TemplateManager.LOADED_EVENT, _OnLevelLoaded);
         TemplateManager.Instance.addEventListener(TemplateManager.FAILED_EVENT, _OnLevelLoadFailed);
         TemplateManager.Instance.LoadFile(PBEngineTestSuite.TestLevel);
      }
      
      private function _OnLevelLoaded(event:Event):void
      {
         assertTrue(TemplateManager.Instance.GetXML("TestTemplate1"));
         assertTrue(TemplateManager.Instance.GetXML("TestTemplate2"));
         assertTrue(TemplateManager.Instance.GetXML("CyclicalTestTemplate1"));
         assertTrue(TemplateManager.Instance.GetXML("CyclicalTestTemplate2"));
         assertTrue(TemplateManager.Instance.GetXML("TestEntity1"));
         assertTrue(TemplateManager.Instance.GetXML("TestEntity2"));
         assertTrue(TemplateManager.Instance.GetXML("SimpleGroup"));
         assertTrue(TemplateManager.Instance.GetXML("ComplexGroup"));
         assertTrue(TemplateManager.Instance.GetXML("CyclicalGroup1"));
         assertTrue(TemplateManager.Instance.GetXML("CyclicalGroup2"));
         
         var testTemplate1:IEntity = TemplateManager.Instance.InstantiateEntity("TestTemplate1");
         assertTrue(testTemplate1);
         assertEquals(19, testTemplate1.GetProperty(_testValueAReference));
         assertEquals(null, NameManager.Instance.Lookup("TestTemplate1"));
         testTemplate1.Destroy();
         
         var testTemplate2:IEntity = TemplateManager.Instance.InstantiateEntity("TestTemplate2");
         assertTrue(testTemplate2);
         assertEquals(43, testTemplate2.GetProperty(_testValueAReference));
         testTemplate2.Destroy();
         
         var cyclicalTemplate:IEntity = TemplateManager.Instance.InstantiateEntity("CyclicalTestTemplate1");
         assertEquals(null, cyclicalTemplate);
         
         var testEntity1:IEntity = TemplateManager.Instance.InstantiateEntity("TestEntity1");
         assertTrue(testEntity1);
         assertEquals(testEntity1, NameManager.Instance.Lookup("TestEntity1"));
         assertEquals(14, testEntity1.GetProperty(_testValueAReference));
         assertEquals(81.347, testEntity1.GetProperty(_testComplexXReference));
         assertEquals(92.762, testEntity1.GetProperty(_testComplexYReference));
         
         var bComponent:TestComponentB = testEntity1.LookupComponentByType(TestComponentB) as TestComponentB;
         assertEquals(bComponent.GetTestValueFromA(), 14);
         
         var testEntity2:IEntity = TemplateManager.Instance.InstantiateEntity("TestEntity2");
         assertTrue(testEntity2);
         assertEquals(testEntity2, NameManager.Instance.Lookup("TestEntity2"));
         assertEquals(638, testEntity2.GetProperty(_testValueAReference));
         assertEquals(1036, testEntity2.GetProperty(_testValueA2Reference));
         assertEquals(8.237, testEntity2.GetProperty(_testComplexXReference));
         assertEquals(12.4, testEntity2.GetProperty(_testComplexYReference));
         
         var aComponent:TestComponentA = testEntity2.LookupComponentByName("A") as TestComponentA;
         assertEquals(testEntity1, aComponent.NamedReference);
         assertTrue(aComponent.InstantiatedReference);
         assertEquals(bComponent, aComponent.ComponentReference);
         assertEquals(bComponent, aComponent.NamedComponentReference);
         
         testEntity1.Destroy();
         testEntity2.Destroy();
         
         var testGroup1:Array = TemplateManager.Instance.InstantiateGroup("SimpleGroup");
         assertEquals(2, testGroup1.length);
         testGroup1[0].Destroy();
         testGroup1[1].Destroy();
         
         var testGroup2:Array = TemplateManager.Instance.InstantiateGroup("ComplexGroup");
         assertEquals(3, testGroup2.length);
         testGroup2[0].Destroy();
         testGroup2[1].Destroy();
         testGroup2[2].Destroy();
         
         var cyclicalGroup:Array = TemplateManager.Instance.InstantiateGroup("CyclicalGroup1");
         assertEquals(null, cyclicalGroup);
         
         TemplateManager.Instance.UnloadFile(PBEngineTestSuite.TestLevel);
         assertTrue(!TemplateManager.Instance.GetXML("TestTemplate1"));
         assertTrue(!TemplateManager.Instance.GetXML("TestTemplate2"));
         assertTrue(!TemplateManager.Instance.GetXML("CyclicalTestTemplate1"));
         assertTrue(!TemplateManager.Instance.GetXML("CyclicalTestTemplate2"));
         assertTrue(!TemplateManager.Instance.GetXML("TestEntity1"));
         assertTrue(!TemplateManager.Instance.GetXML("TestEntity2"));
         assertTrue(!TemplateManager.Instance.GetXML("SimpleGroup"));
         assertTrue(!TemplateManager.Instance.GetXML("ComplexGroup"));
         assertTrue(!TemplateManager.Instance.GetXML("CyclicalGroup1"));
         assertTrue(!TemplateManager.Instance.GetXML("CyclicalGroup2"));
         
         Logger.PrintFooter(null, "");
      }
      
      private function _OnLevelLoadFailed(event:Event):void
      {
         assertTrue(false);
         Logger.PrintFooter(null, "");
      }
      
      private var _testValueAReference:PropertyReference = new PropertyReference("@A.TestValue");
      private var _testValueA2Reference:PropertyReference = new PropertyReference("@A2.TestValue");
      private var _testComplexXReference:PropertyReference = new PropertyReference("@B.TestComplex.x");
      private var _testComplexYReference:PropertyReference = new PropertyReference("@B.TestComplex.y");
   }
}