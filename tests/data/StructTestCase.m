classdef StructTestCase < matlab.unittest.TestCase
  %% STRUCTTESTCASE
  
  
  
  methods ( Test )
    
    function testStructurePlus(obj)
      %% TESTSTRUCTUREPLUS
      
      
      a = struct('foo', 'bar');
      b = struct('bar', 'baz');
      
      c = a + b;
      
      import matlab.unittest.constraints.*
      
      assertThat(obj, c, IsOfClass(?struct));
      assertThat(obj, fieldnames(c), IsSameSetAs({'foo', 'bar'}));
      assertThat(obj, c.foo, IsEqualTo(a.foo));
      assertThat(obj, c.bar, IsEqualTo(b.bar));
      
    end
    
    
    function testStructureMinusNonexistingFields(obj)
      %% TESTSTRUCTUREMINUSNONEXISTINGFIELDS
      
      
      
      a = struct('foo', 'bar');
      b = struct('bar', 'baz');
      
      c = a - b;
      
      import matlab.unittest.constraints.*
      
      assertThat(obj, c, IsOfClass(?struct));
      assertThat(obj, fieldnames(c), IsSameSetAs({'foo'}));
      assertThat(obj, c.foo, IsEqualTo(a.foo));
      
    end
    
    
    function testStructureMinusExistingFields(obj)
      %% TESTSTRUCTUREMINUSEXISTINGFIELDS
      
      
      
      a = struct('foo', 'bar', 'bar', 'booz');
      b = struct('bar', 'baz');
      
      c = a - b;
      
      import matlab.unittest.constraints.*
      
      assertThat(obj, c, IsOfClass(?struct));
      assertThat(obj, fieldnames(c), IsSameSetAs({'foo'}));
      assertThat(obj, c.foo, IsEqualTo(a.foo));
      
    end
    
    
    function testStructureTimes(obj)
      %% TESTSTRUCTURETIMES
      
      
      
      a = struct('foo', 'bar');
      b = struct('foo', 'fob', 'bar', 'baz');
      
      c = a * b;
      
      import matlab.unittest.constraints.*
      
      assertThat(obj, c, IsOfClass(?struct));
      assertThat(obj, fieldnames(c), IsSameSetAs({'foo'}));
      assertThat(obj, c.foo, IsEqualTo(b.foo));
      
    end
    
    
    function testStructureDivide(obj)
      %% TESTSTRUCTUREDIVIDE
      
      
      
      a = struct('foo', 'bar', 'baz', 'foob');
      b = struct('foo', 'fob');
      
      c = a / b;
      
      import matlab.unittest.constraints.*
      
      assertThat(obj, c, IsOfClass(?struct));
      assertThat(obj, fieldnames(c), IsSameSetAs({'baz'}));
      assertThat(obj, c.baz, IsEqualTo(a.baz));
      
    end
    
  end
  
end
