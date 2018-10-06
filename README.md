# ReadBytes(), WriteBytes() procedures with COPY

This is an experimental module *Files2.Mod* with enhanced procedures handling multibyte transfer making use of *SYSTEM.COPY()*. As COPY moves 4-byte words around, the avarage speed up is 400%.

Both *ReadBytes()*, *WriteBytes()*, could be helpful when storing and loading program data structures with regular files. Typical code pattern could be like this.

**Loading stuct from file**
	IMPORT S := SYSTEM;
	...
	TYPE
	  R1 = POINTER TO R1Desc;
	  R1Desc = RECORD a, b, c, d: CHAR; i: INTEGER END;
	  Buf = ARRAY S.SIZE(R1Desc) OF BYTE;
	...
	VAR f: Files.File; r: Files.Rider;
	  r1: R1; buf: Buf;
	...
	Files.ReadBytes(R, buf, S.SIZE(R1Desc));
	r1 := S.VAL(R1, S.ADR(buf));

**Loading array from file**
	IMPORT S := SYSTEM;
	...
	TYPE
	  A8 = ARRAY 3 OF INTEGER;
	  BufA8 = ARRAY S.SIZE(A8) OF BYTE;
	...
	VAR f: Files.File; r: Files.Rider;
	  a8: A8;
	...
	Files.ReadBytes(r, S.VAL(BufA8, a8), S.SIZE(A8));

Storing is analogous.

# Test module

FilesTest.Mod - unit test with common cases
FilesTest - input data file
FilesTest2 - output data file
Out.Mod - console output

