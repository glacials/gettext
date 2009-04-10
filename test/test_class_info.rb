require 'testlib/helper.rb'
require 'gettext/class_info'

module M1; end
module M2; end

module M1
  module M3
    include M2
    module M4; end
    class C1; end
  end
  class C2
    module M5
      class C4; end
    end
    class C3; end
  end
end

module M1::M6
  include M1::M3::M4
  module M7; end
end

module M8
  module M9
  end
  include M9
end

# Anonymous module
@@anon = Module.new
class @@anon::AC1; end
module @@anon::AM1; end

class TestClassInfo < Test::Unit::TestCase
  include GetText::ClassInfo

  def test_normalize_class
    assert_equal M1::M3, normalize_class(M1::M3)
    assert_equal M1::M3::C1, normalize_class(M1::M3::C1)
    assert_equal M1::M3::C1, normalize_class(M1::M3::C1.new)

    assert_equal NilClass, normalize_class(nil)
    assert_equal TestClassInfo, normalize_class(self)
  end

  def test_normalize_class_anonymous_module
    assert_equal Object, normalize_class(@@anon)
    assert_equal Object, normalize_class(@@anon)
    assert_equal Object, normalize_class(@@anon::AC1)
    assert_equal Object, normalize_class(@@anon::AM1)
  end

  def test_related_classes
    assert_equal [M1, Object], related_classes(M1)
    assert_equal [M1::M3, M1, M2, Object], related_classes(M1::M3)
    assert_equal [M1::M3::M4, M1::M3, M1, M2, Object], related_classes(M1::M3::M4)
    assert_equal [M1::M3::C1, M1::M3, M1, M2, Object], related_classes(M1::M3::C1)
    assert_equal [M1::C2, M1, Object], related_classes(M1::C2)
    assert_equal [M1::C2::M5::C4, M1::C2::M5, M1::C2, M1, Object], related_classes(M1::C2::M5::C4)
    assert_equal [M1::C2::C3, M1::C2, M1, Object], related_classes(M1::C2::C3)
    assert_equal [M1::M6, M1, M1::M3::M4, M1::M3, M2, Object], related_classes(M1::M6)
    assert_equal [M1::M6::M7, M1::M6, M1, M1::M3::M4, M1::M3, M2, Object], related_classes(M1::M6::M7)
  end

  def test_rellated_classes_with_all_classes
    assert_equal [M1, Object], related_classes(M1, [M1])
    assert_equal [M1, Object], related_classes(M1::M3::M4, [M1])
    assert_equal [M1::M3, Object], related_classes(M1::M3::M4, [M1::M3])
    assert_equal [M1::M3, M1, Object], related_classes(M1::M3::M4, [M1::M3, M1])
  end

  def test_related_classes_loop_mixin
    assert_equal [M8, M8::M9, Object], related_classes(M8)
  end

end
