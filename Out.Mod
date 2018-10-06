MODULE Out;
  IMPORT Texts, Oberon;
  VAR W: Texts.Writer;

  PROCEDURE Char*(ch: CHAR);
  BEGIN Texts.Write(W, ch); Texts.Append(Oberon.Log, W.buf)
  END Char;

  PROCEDURE String*(s: ARRAY OF CHAR);
  BEGIN Texts.WriteString(W, s)
  END String;

  PROCEDURE Int*(i, n: INTEGER);
  BEGIN Texts.WriteInt(W, i, n)
  END Int;

  PROCEDURE Hex*(i: INTEGER);
  BEGIN Texts.WriteHex(W, i)
  END Hex;

  PROCEDURE Real*(x: REAL; n: INTEGER);
  BEGIN Texts.WriteReal(W, x, n)
  END Real;

  PROCEDURE Bool*(bl: BOOLEAN);
  BEGIN IF bl THEN Texts.WriteString(W, "TRUE") ELSE Texts.WriteString(W, "FALSE") END
  END Bool;

  (* write word [wd] in binary, n=[1..32] number of bits to print, reverse order *)
  PROCEDURE Bin*(wd, n: INTEGER);
    VAR i: INTEGER;
  BEGIN
    FOR i := 0 TO n-1 DO
      IF ODD(wd) THEN Char("1") ELSE Char("0") END ;
      wd := wd DIV 2
    END
  END Bin;

  PROCEDURE Ln*;
  BEGIN
    Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
  END Ln;

BEGIN Texts.OpenWriter(W)
END Out.
