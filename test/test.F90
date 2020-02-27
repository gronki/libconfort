program test_confort

    use confort
    use iso_fortran_env
    use iso_c_binding

#   define test(x) test0(__FILE__,__LINE__,x,"x")
#   define ftest(x) ftest0(__FILE__,__LINE__,x,"x")

    type(config) :: cfg
    character(len=150) :: buf
    integer :: errno
    character(len=*), parameter :: fn = "test.cfg"
    character(len=*), parameter :: key_wrong = "thereisnouschkey"
    character(len=*), parameter :: key_ok = "key1"
    character(len=*), parameter :: value_ok = "value1"
    character(len=*), parameter :: def = "domyslna"

    character(len=*), parameter :: fnbad = "Tegoplikuniema"

    call mincf_read_file(cfg, fnbad, errno)
    call test(errno .ne. 0)
    call mincf_free(cfg)

    call mincf_read_file(cfg, fn, errno)

    if (ftest(errno .eq. MINCF_OK)) then

        call test( mincf_exists(cfg,key_ok) )
        call test( .not. mincf_exists(cfg,key_wrong) )

        call mincf_get(cfg, key_wrong, buf, errno)
        call mincf_print_error(errno,__FILE__,__LINE__)
        call test(iand(errno, MINCF_NOT_FOUND) .ne. 0)

        call mincf_get(cfg, key_ok, buf, def, errno)
        call mincf_print_error(errno,__FILE__,__LINE__)
        call test(iand(errno, MINCF_NOT_FOUND) .eq. 0)
        call test(buf .eq. value_ok)

        call mincf_get(cfg, key_wrong, buf, def, errno)
        call mincf_print_error(errno,__FILE__,__LINE__)
        call test(iand(errno, MINCF_NOT_FOUND) .eq. 0)
        call test(buf .eq. def)

        call mincf_get(cfg, "test_overwrite_1", buf, errno)
        call mincf_print_error(errno,__FILE__,__LINE__)
        call test(errno .eq. MINCF_OK)
        call mincf_get(cfg, "test_overwrite_2", buf, errno)
        call mincf_print_error(errno,__FILE__,__LINE__)
        if ( ftest(errno .eq. MINCF_OK) ) then
            call test(buf .eq. 'A very short comment.')
            write(6, "('buffer content: ',A)") buf
        end if

        call mincf_free(cfg)

    end if

contains

    subroutine test0(file,line,l,name)
        character(len=*), intent(in) :: file,name
        integer, intent(in) :: line
        logical, intent(in) :: l
        character(len=*), parameter :: fmt = '(A," has ",A," the test (line ",I0,"): ",A)'

        if (l) then
            write (*,fmt)  file,  "PASSED", line, name
        else
            write (*,fmt)  file,  "FAILED", line, name
        end if
    end subroutine

    logical function ftest0(file,line,l,name)
        character(len=*), intent(in) :: file,name
        integer, intent(in) :: line
        logical, intent(in) :: l
        character(len=*), parameter :: fmt = '(A," has ",A," the test (line ",I0,"): ",A)'

        if (l) then
            write (*,fmt)  file,  "PASSED", line, name
        else
            write (*,fmt)  file,  "FAILED", line, name
        end if

        ftest0 = l
    end function

end program
