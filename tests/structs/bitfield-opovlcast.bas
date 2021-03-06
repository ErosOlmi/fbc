
# include "fbcu.bi"

namespace fbc_tests.structs.bitfield_opovlcast

enum BOOL
  false = 0
  true  = 1
end enum

type MMN_CPU
  union
  	as integer   all
  	as integer   fpu :1
  	as integer   tsc :1
  	as integer   cmov:1
  	as integer   mmx :1
  	as integer   mmx2:1
  	as integer   sse :1
  	as integer   sse2:1
  	as integer   n3D :1
  	as integer   n3D2:1
  end union
end type

dim shared me as MMN_CPU

function IsFPU()  as bool
  return me.fpu
end function

function IsTSC()  as bool
  return me.tsc
end function

sub test cdecl ()
	me.all = -1
	
	CU_ASSERT_TRUE( IsFPU() )
	
	CU_ASSERT_TRUE( IsTSC() )
end sub

private sub ctor () constructor

	fbcu.add_suite("fbc_tests.structs.bitfield_opovlcast")
	fbcu.add_test("test", @test)

end sub

end namespace
