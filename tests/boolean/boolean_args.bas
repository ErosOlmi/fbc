# include "fbcu.bi"

'' - don't mix false/true intrinsic constants 
''   of the compiler in with the tests
#undef FALSE
#undef TRUE

#define FALSE 0
#define TRUE -1

namespace fbc_tests.boolean_.args

	''
	sub foo1( byval b as boolean, byval i as integer )
		CU_ASSERT_EQUAL( b, cbool(i) )
	end sub

	''
	sub pass_by_value cdecl ( )

		dim as integer i

		'' literal - implicit conversion
		foo1(  0,  0 )
		foo1(  1,  1 )
		foo1(  2,  2 )
		foo1( -1, -1 )
		foo1( 256, 256 )

		'' variable - implicit conversion
		i =  0: foo1(  i,  0 )
		i =  1: foo1(  i,  1 )
		i =  2: foo1(  i,  2 )
		i = -1: foo1(  i, -1 )
		i = 256: foo1(  i, 256 )

	end sub

	''
	sub foo2( byref b as boolean, byval i as integer )
		CU_ASSERT_EQUAL( b, cbool(i) )
	end sub

	''
	sub pass_by_ref cdecl ( )

		dim as boolean b

		'' literal - implicit conversion
		foo2(  0,  0 )
		foo2(  1,  1 )
		foo2(  2,  2 )
		foo2( -1, -1 )
		foo2( 256, 256 )

		'' variable - implicit conversion
		b =  0: foo2(  b, 0 )
		CU_ASSERT_EQUAL( b, FALSE )

		b =  1: foo2(  b, 1 )
		CU_ASSERT_EQUAL( b, TRUE )

		b =  2: foo2(  b, 2 )
		CU_ASSERT_EQUAL( b, TRUE )

		b = -1: foo2(  b, -1 )
		CU_ASSERT_EQUAL( b, TRUE )

		b = 256: foo2(  b, 256 )
		CU_ASSERT_EQUAL( b, TRUE )

	end sub

	''
	sub foo3( byval b as boolean ptr, byval i as integer )
		CU_ASSERT_EQUAL( *b, cbool(i) )
	end sub

	''
	sub pass_by_pointer cdecl ( )

		dim b as boolean
		dim pb as boolean ptr = @b

		b =  0: foo3( pb, 0 )
		CU_ASSERT_EQUAL( *pb, FALSE )
		CU_ASSERT_EQUAL( b, FALSE )

		b =  1: foo3( pb, 1 )
		CU_ASSERT_EQUAL( *pb, TRUE )
		CU_ASSERT_EQUAL( b, TRUE )

		b =  2: foo3( pb, 2 )
		CU_ASSERT_EQUAL( *pb, TRUE )
		CU_ASSERT_EQUAL( b, TRUE )

		b = -1: foo3( pb, -1 )
		CU_ASSERT_EQUAL( *pb, TRUE )
		CU_ASSERT_EQUAL( b, TRUE )

		b = 256: foo3( pb, 256 )
		CU_ASSERT_EQUAL( *pb, TRUE )
		CU_ASSERT_EQUAL( b, TRUE )

	end sub

	''
	function foo4( byval i as integer ) as boolean
		return i
	end function

	''
	sub return_bool cdecl ( )
		
		dim as integer i

		CU_ASSERT_EQUAL( foo4(0), FALSE )		
		CU_ASSERT_EQUAL( foo4(1), TRUE )		
		CU_ASSERT_EQUAL( foo4(2), TRUE )		
		CU_ASSERT_EQUAL( foo4(-1), TRUE )		
		CU_ASSERT_EQUAL( foo4(256), TRUE )		
		
		i = foo4(0)
		CU_ASSERT_EQUAL( i, FALSE )

		i = foo4(1)
		CU_ASSERT_EQUAL( i, TRUE )

		i = foo4(2)
		CU_ASSERT_EQUAL( i, TRUE )

		i = foo4(-1)
		CU_ASSERT_EQUAL( i, TRUE )

		i = foo4(256)
		CU_ASSERT_EQUAL( i, TRUE )

	end sub

	''
	sub foo5( byref b as boolean, byval i as integer )
		CU_ASSERT_EQUAL( b, cbool(i) )
		b = FALSE
	end sub

	''
	sub foo6( byref b as boolean, byval i as integer )
		CU_ASSERT_EQUAL( b, cbool(i) )
		b = TRUE
	end sub

	''
	sub pass_by_ref_mod cdecl ( )

		dim as boolean b

		'' variable / modified
		b =  0: foo5(  b, 0 )
		CU_ASSERT_EQUAL( b, FALSE )
		b =  0: foo6(  b, 0 )
		CU_ASSERT_EQUAL( b, TRUE )

		b =  1: foo5(  b, 1 )
		CU_ASSERT_EQUAL( b, FALSE )
		b =  1: foo6(  b, 1 )
		CU_ASSERT_EQUAL( b, TRUE )

		b =  2: foo5(  b, 2 )
		CU_ASSERT_EQUAL( b, FALSE )
		b =  2: foo6(  b, 2 )
		CU_ASSERT_EQUAL( b, TRUE )

		b =  -1: foo5(  b, -1 )
		CU_ASSERT_EQUAL( b, FALSE )
		b =  -1: foo6(  b, -1 )
		CU_ASSERT_EQUAL( b, TRUE )

		b =  256: foo5(  b, 256 )
		CU_ASSERT_EQUAL( b, FALSE )
		b =  256: foo6(  b, 256 )
		CU_ASSERT_EQUAL( b, TRUE )

	end sub

	''
	private sub ctor () constructor
	
		fbcu.add_suite("fbc_tests.boolean_.args")
		fbcu.add_test("pass_by_value", @pass_by_value)
		fbcu.add_test("pass_by_ref", @pass_by_ref)
		fbcu.add_test("pass_by_ref_mod", @pass_by_ref_mod)
		fbcu.add_test("pass_by_pointer", @pass_by_pointer)
		fbcu.add_test("return_bool", @return_bool)
		
	end sub
	
end namespace
