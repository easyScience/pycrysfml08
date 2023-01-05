!-------------------------------------------------------------
! PyCrysFML08
! -------------------------------------------------------------
! This file is part of PyCrysFML08
!
! The PyCrysFML08 is distributed under LGPL. In agreement with the
! Intergovernmental Convention of the ILL, this software cannot be used
! in military applications.
!
! PyCrysFML08 is based on Elias Rabel work for Forpy, see <https://github.com/ylikx/forpy>.
!
! Copyright (C) 2020-2022  Institut Laue-Langevin (ILL), Grenoble, FRANCE
!
! Authors: Nebil A. Katcho (ILL)
!          Juan Rodriguez-Carvajal (ILL)
!
!
!
! This library is free software; you can redistribute it and/or
! modify it under the terms of the GNU Lesser General Public
! License as published by the Free Software Foundation; either
! version 3.0 of the License, or (at your option) any later version.
!
! This library is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
! Lesser General Public License for more details.
!
! You should have received a copy of the GNU Lesser General Public
! License along with this library; if not, see <http://www.gnu.org/licenses/>.
!
! -------------------------------------------------------------


module api_init

    use forpy_mod
    use iso_c_binding
    use extension_cfml_ioform
    use extension_cfml_sxtal_geom

    implicit none

    type(PythonModule), save :: mod_Def
    type(PythonMethodTable), save :: method_Table

    contains

    ! Initialization function for Python 3
    ! Called when importing module
    ! Must use bind(c, name="PyInit_<module name>")
    ! Return value must be type(c_ptr),
    ! use the return value of PythonModule%init
    function PyInit_pycrysfml08() bind(c,name="PyInit_pycrysfml08") result(m)
    !DEC$ ATTRIBUTES DLLEXPORT :: PyInit_pycrysfml08

        ! Local variables
        type(c_ptr) :: m

        m = Init()

    end function PyInit_pycrysfml08

    function Init() result(m)

        ! Local variables
        type(c_ptr) :: m
        integer :: ierror

        ierror = Forpy_Initialize()

        ! Build method table
        call method_Table%init(2)
        call method_Table%add_method("xtal_structure_from_file",&
            "py_xtal_structure_from_file",METH_VARARGS,&
            c_funloc(py_xtal_structure_from_file))
        call method_Table%add_method("ganu_from_xz",&
            "py_ganu_from_xz",METH_VARARGS,&
            c_funloc(py_ganu_from_xz))

        ! Build mod_Def
        m = mod_Def%init("pycrysfml08","A Python API for CrysFML08",method_Table)

    end function Init

end module api_init