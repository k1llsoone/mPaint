
program mPaint;

uses
  graphABC;
var
  name: char := ' ';
  v1, v2, v3, v: integer;
  pic: picture;

const
  w = 1240; h = 600;  m = 45;

procedure DrawCaption(x, y: integer);
var
  s: string;
begin
  s := '';
  if (x >= 0) and (y >= 0) then
    s := s + '' + name;
  window.caption := s;
end;

procedure erase0(x, y, p: integer);
begin
  brush.color := rgb(255, 255, 255);
  fillrect(x - m, y - m, x + m, y + m);
end;

procedure mmove(x, y, b: integer);
begin
  if b = 1 then
    lineto(x, y);
  if b = 2 then
    erase0(x, y, pen.Width);
end;

procedure kpress(c: char);
var
  p: integer;
  s: string;
  t: color;
begin
  p := pen.width;
  case c of
    '0':
      begin
        v1 := 0; v2 := 0; v3 := 0;
        pen.Color := rgb(v1, v2, v3);
        brush.Color := pen.Color;
        circle(m, m, p);
      end;
    '1':
      begin
        v1 := v1 + 64;
        pen.Color := rgb(v1 - 1, v2, v3);
        brush.Color := pen.Color;
        circle(m, m, p);
      end;
    '2':
      begin
        v2 := v2 + 64;
        pen.Color := rgb(v1, v2 - 1, v3);
        brush.Color := pen.Color;
        circle(m, m, p);
      end;
    '3':
      begin
        v3 := v3 + 64;
        pen.Color := rgb(v1, v2, v3 - 1);
        brush.Color := pen.Color;
        circle(m, m, p);
      end;
    '4':
      begin
        v1 := 255; v2 := 255; v3 := 255;
        pen.Color := rgb(v1, v2, v3);
        brush.Color := pen.Color;
        circle(m, m, p);
      end;
    '=':
      begin
        v := v + 16;
        pen.Color := argb(v + 1, v1, v2, v3);
        t := pen.Color;
        SetBrushColor(clwhite);
        setpencolor(clwhite);
        circle(m, m, p);
        brush.Color := t;
        pen.Color := t;
        circle(m, m, p);
      end;
    ',':
      begin
        p := p - 1;
        t := pen.Color;
        SetBrushColor(clwhite);
        setpencolor(clwhite);
        circle(m, m, p + 3);
        brush.Color := t;
        pen.Color := t;
        circle(m, m, p);
      end;   
    '.':
      begin
        p := p + 1;
        circle(m, m, p);
      end;
    '<':
      begin
        p := p - 5;
        t := pen.Color;
        SetBrushColor(clwhite);
        setpencolor(clwhite);
        circle(m, m, p + 3);
        brush.Color := t;
        pen.Color := t;
        circle(m, m, p);
      end;
    '>':
      begin
        p := p + 5;
        circle(m, m, p);
      end;
    'a'..'z': 
      if name <> upcase(c) then
      begin
        window.Save(c + '.png');
        name := upcase(c);
        font.Color := rgb(0, 0, 0);
        brush.color := rgb(255, 255, 255);
        textout(100, 10, 'Файл сохранен');
        sleep(1000);
        brush.Color := pen.Color;
        window.Clear;
        window.Load(c + '.png');
      end;
    'A'..'Z': 
      if fileexists(c + '.png') then
      begin
        window.Load(c + '.png');
        name := c;
        font.Color := rgb(0, 0, 0);
        brush.color := rgb(255, 255, 255);
        textout(100, 10, 'Файл загружен'); 
        sleep(1000);
        brush.Color := pen.Color;
        window.Clear;
        window.Load(c + '.png');
      end;
  else
    exit;     
  end;
  if p < 1 then
    p := 1;
  if p > 30 then
    p := 30;
  pen.width := p;
  drawcaption(-1, 0);
end;


procedure mdown(x, y, b: integer);
begin
  drawcaption(x, y);
  if b = 1 then
  begin
    moveto(x, y);
  end;
  if b = 2 then
    erase0(x, y, pen.Width);
end;

procedure kdown(k: integer);
begin
  case k of
    vk_escape:
      begin
        window.Clear;
        brush.Color := pen.Color;
        circle(m, m, pen.Width);
      end;
    vk_right: lineto(pen.X + 5, pen.Y);
    vk_left: lineto(pen.X - 5, pen.Y);
    vk_up: lineto(pen.X, pen.Y - 5);
    vk_down: lineto(pen.X, pen.Y + 5);
    vk_home: lineto(pen.X - 5, pen.Y - 5);
    vk_pagedown: lineto(pen.X + 5, pen.Y + 5);
    vk_pageup: lineto(pen.X + 5, pen.Y - 5);
    vk_end: lineto(pen.X - 5, pen.Y + 5);
  end;
end;

begin
  {$apptype windows}
  pic := Picture.Create('logo.jpg');
  pic.draw(0, 82, 200, 50);
  brush.Color := pen.Color;
  circle(m, m, pen.Width);
  window.SetSize(w, h);
  window.CenterOnScreen;
  onmousemove := mmove;
  onmousedown := mdown;
  onkeypress := kpress;
  onkeydown := kdown;
  pen.NETPen.StartCap := system.drawing.drawing2d.linecap.round;
  window.Title := ('mPaint v2.5');
  pen.NETPen.EndCap := pen.NETPen.StartCap;
end.