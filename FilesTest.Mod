MODULE FilesTest; (*TK 18.10.2018 Testing Read/Write Bytes with COPY*)
  IMPORT S := SYSTEM, Files := Files2, O := Out;

  TYPE
    R1 = POINTER TO R1Desc;
    R2 = POINTER TO R2Desc;
    R3 = POINTER TO R3Desc;
    R4 = POINTER TO R4Desc;
    R1Desc = RECORD a, b, c, d: CHAR END;
    R2Desc = RECORD a: ARRAY 2 OF CHAR; b: ARRAY 2 OF CHAR END;
    R3Desc = RECORD a: ARRAY 1 OF CHAR; b: ARRAY 1 OF CHAR; c: ARRAY 1 OF CHAR; d: ARRAY 1 OF CHAR END;
    R4Desc = RECORD a: ARRAY 3 OF INTEGER END;
    A1 = ARRAY 1 OF BYTE;
    A2 = ARRAY 2 OF BYTE;
    A3 = ARRAY 3 OF BYTE;
    A4 = ARRAY 4 OF BYTE;
    A5 = ARRAY 5 OF BYTE;
    A7 = ARRAY 7 OF BYTE;
    A8 = ARRAY 3 OF INTEGER; BufA8 = ARRAY S.SIZE(A8) OF BYTE;
    Buf = ARRAY 16 OF BYTE;
    Buf1K = ARRAY 1024 OF BYTE;

  VAR f, F: Files.File; r, R: Files.Rider; ch: CHAR;
    r1: R1; r2: R2; r3: R3; r4: R4; buf: Buf; buf1k: Buf1K;
    a1: A1; a2: A2; a3: A3; a4: A4; a5: A5; a7: A7; a8: A8;

  PROCEDURE Dump(VAR a: ARRAY OF BYTE);
    VAR i: INTEGER;
  BEGIN FOR i := 0 TO LEN(a)-1 DO O.Char(CHR(a[i])) END ; O.Ln
  END Dump;

  PROCEDURE Clear(VAR a: ARRAY OF BYTE; fill: BYTE);
    VAR i: INTEGER;
  BEGIN FOR i := 0 TO LEN(a)-1 DO a[i] := fill END
  END Clear;

  PROCEDURE Size;
  BEGIN (*report size of structs & arrays*)
    O.Int(S.SIZE(R1Desc), 4); O.Int(S.SIZE(R2Desc), 4);
    O.Int(S.SIZE(R3Desc), 4); O.Int(S.SIZE(R4Desc), 4); O.Ln;
    O.Int(S.SIZE(A1), 4); O.Int(S.SIZE(A2), 4); O.Int(S.SIZE(A3), 4);
    O.Int(S.SIZE(A4), 4); O.Int(S.SIZE(A5), 4); O.Ln
  END Size;

  PROCEDURE Read*;
  BEGIN Size;
    (*file size < SS*)
    F := Files.Old("FilesTest"); Files.Set(R, F, 0);

    (*structs*)
    Clear(buf, 0); Files.ReadBytes(R, buf, S.SIZE(R1Desc)); Dump(buf);
    r1 := S.VAL(R1, S.ADR(buf));
    O.Char(r1.a); O.Char(r1.b); O.Char(r1.c); O.Char(r1.d); O.Ln;
    Clear(buf, 0); Files.ReadBytes(R, buf, S.SIZE(R2Desc)); Dump(buf);
    r2 := S.VAL(R2, S.ADR(buf));
    O.Char(r2.a[0]); O.Char(r2.a[1]); O.Char(r2.b[0]); O.Char(r2.b[1]); O.Ln;
    Clear(buf, 0); Files.ReadBytes(R, buf, S.SIZE(R3Desc)); Dump(buf);
    r3 := S.VAL(R3, S.ADR(buf));
    O.Char(r3.a[0]); O.Char(r3.b[0]); O.Char(r3.c[0]); O.Char(r3.d[0]); O.Ln;
    Clear(buf, 0); Files.ReadBytes(R, buf, S.SIZE(R4Desc));
    r4 := S.VAL(R4, S.ADR(buf)); O.Int(r4.a[0], 4); O.Int(r4.a[1], 4); O.Int(r4.a[2], 4); O.Ln;
    O.Bool(R.eof); O.Int(R.res, 3); O.Ln;

    (*arrays*)
    Files.ReadBytes(R, a7, LEN(a7)); Dump(a7);
    Files.ReadBytes(R, a1, LEN(a1)); Dump(a1);
    Files.ReadBytes(R, a2, LEN(a2)); Dump(a2);
    Files.ReadBytes(R, a3, LEN(a3)); Dump(a3);
    Files.ReadBytes(R, a4, LEN(a4)); Dump(a4);
    Files.ReadBytes(R, a5, LEN(a5)); Dump(a5);
    Files.ReadBytes(R, S.VAL(BufA8, a8), S.SIZE(A8)); O.Int(a8[0], 4); O.Int(a8[1], 4); O.Int(a8[2], 4);  O.Ln;
    O.Bool(R.eof); O.Int(R.res, 3); O.Ln;

    (*file size > SS*)
    Files.Read(R, ch); Files.Read(R, ch); (*move to word boundary pos=76*) O.Int(Files.Pos(R), 3);
    Clear(buf1k, 0); Files.ReadBytes(R, buf1k, LEN(buf1k)); Dump(buf1k);
    O.Bool(R.eof); O.Int(R.res, 4); O.Ln;
    Clear(buf1k, 0); Files.ReadBytes(R, buf1k, (*LEN(buf1k)*) 254); Dump(buf1k);
    O.Bool(R.eof); O.Int(R.res, 4); O.Ln
  END Read;

  PROCEDURE Write*;
  BEGIN Size;
    (*file size < SS*)
    F := Files.New("FilesTest2"); Files.Set(R, F, 0);

    (*structs*)
    Clear(buf, ORD(".")); r1 := S.VAL(R1, S.ADR(buf));
    r1.a := "a"; r1.b := "b"; r1.c := "c"; r1.d := "d"; Dump(buf);
    Files.WriteBytes(R, buf, S.SIZE(R1Desc));
    Clear(buf, ORD(".")); r2 := S.VAL(R2, S.ADR(buf));
    r2.a[0] := "a"; r2.a[1] := "a"; r2.b[0] := "b"; r2.b[1] := "b"; Dump(buf);
    Files.WriteBytes(R, buf, S.SIZE(R2Desc));
    Clear(buf, ORD(".")); r3 := S.VAL(R3, S.ADR(buf));
    r3.a[0] := "a"; r3.b[0] := "b"; r3.c[0] := "c"; r3.d[0] := "d"; Dump(buf);
    Files.WriteBytes(R, buf, S.SIZE(R3Desc));
    Clear(buf, 0); r4 := S.VAL(R4, S.ADR(buf));
    r4.a[0] := 111H; r4.a[1] := 222H; r4.a[2] := 333H; O.Int(r4.a[0], 4); O.Int(r4.a[1], 4); O.Int(r4.a[2], 4); O.Ln;
    Files.WriteBytes(R, buf, S.SIZE(R4Desc));
    
    (*arrays*)
    Clear(a7, ORD("7")); Dump(a7);
    Files.WriteBytes(R, a7, LEN(a7));
    Clear(a1, ORD("1")); Dump(a1);
    Files.WriteBytes(R, a1, LEN(a1));
    Clear(a2, ORD("2")); Dump(a2);
    Files.WriteBytes(R, a2, LEN(a2));
    Clear(a3, ORD("3")); Dump(a3);
    Files.WriteBytes(R, a3, LEN(a3));
    Clear(a4, ORD("4")); Dump(a4);
    Files.WriteBytes(R, a4, LEN(a4));
    Clear(a5, ORD("5")); Dump(a5);
    Files.WriteBytes(R, a5, LEN(a5));
    a8[0] := 111H; a8[1] := 222H; a8[2] := 333H; O.Int(a8[0], 4); O.Int(a8[1], 4); O.Int(a8[2], 4);  O.Ln;
    Files.WriteBytes(R, S.VAL(BufA8, a8), S.SIZE(A8));

    (*file size > SS*)
    f := Files.Old("FilesTest"); Files.Set(r, f, 76); (*move to word boundary*) Files.Write(R, "."); Files.Write(R, ".");
    Clear(buf1k, 0); Files.ReadBytes(r, buf1k, LEN(buf1k)); Dump(buf1k);
    Files.WriteBytes(R, buf1k, LEN(buf1k));
    Clear(buf1k, 0); Files.ReadBytes(r, buf1k, (*LEN(buf1k)*) 254); Dump(buf1k);
    Files.WriteBytes(R, buf1k, LEN(buf1k));

    Files.Register(F)
  END Write;

END FilesTest.


FilesTest.Read
FilesTest.Write
