unit UFinal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, OleCtrls, WMPLib_TLB, Math;

type
  TForm1 = class(TForm)
    Menu: TImage;
    Jugar: TLabel;
    Opciones: TLabel;
    Salir: TLabel;
    Image1: TImage;
    Auto: TImage;
    Timer1: TTimer;
    wmp: TWindowsMediaPlayer;
    ApagarMusica: TLabel;
    Highscores: TLabel;
    Creditos: TLabel;
    AtrasOpcionesAMenu: TLabel;
    AtrasCreditosAOpciones: TLabel;
    ScoreBar: TImage;
    Score: TLabel;
    Nube: TImage;
    Objeto: TImage;
    AtrasHighscoresAOpciones: TLabel;
    EscribirNombre: TEdit;
    GuardarScore: TButton;
    ScoreAltoActual: TLabel;
    wmp2: TWindowsMediaPlayer;
    procedure FormCreate(Sender: TObject);
    procedure SalirClick(Sender: TObject);
    procedure JugarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure OpcionesClick(Sender: TObject);
    procedure CreditosClick(Sender: TObject);
    procedure AtrasCreditosAOpcionesClick(Sender: TObject);
    procedure AtrasOpcionesAMenuClick(Sender: TObject);
    procedure ApagarMusicaClick(Sender: TObject);
    procedure AtrasHighscoresAOpcionesClick(Sender: TObject);
    procedure HighscoresClick(Sender: TObject);
    procedure GuardarScoreClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//--------------constantes-----------------------------------------------------------------------------------------------------------

const
      //Constantes pertenecientes al fondo//
      AnchoImagen = 1000;
      AltoImagen = 800;
      AltoCielo = 150;
      SeparacionLineasRuta = 175;
      //Constantes pertenecientes al autito//
      AltoAuto = 120;
      AnchoAuto = 180;
      CentroJugador1 = (AnchoImagen div 2)-(AnchoAuto div 2);
      AlturaJugador1 = AltoImagen-AltoAuto;
      DesplazamientoJ1 = 275;
      //Constantes pertenecientes a la ruta//
      AnchoRutaJ1 = 800;
      CentroRuta = 500;
      //Constantes pertenecientes al arreglo de enemigos//
      NEnemigosPosibles = 6;
      AnchoInicial = 10;
      AltoInicial = 10;
      //Constantes pertenecientes al las nubes//
      AltoNube = 100;
      AnchoNube = 200;
      //Constantes pertenecientes al cactus//
      AltoCactus = 150;
      AnchoCactus = 90;
      AnchoCactusInicial = 20;
      AltoCactusInicial = 20;

//--------tipos----------------------------------------------------------------------------------------------------------------------

type
     TEnemigo = array [1..NEnemigosPosibles] of timage;

//-------variables globales----------------------------------------------------------------------------------------------------------

var
    Iniciar:boolean;
    Enemigo:TEnemigo;
    PuntajeJ1:integer;
    ArranqueNube:integer;
    Obj:integer;
    ladoObj:integer;
    asigneObj:boolean;
    continuar,continuar2,continuarFilaAtras:boolean;
    lado1:1..3;
    lado2:4..6;
    choque,choque1,choque2,choque3,choque4,choque5,choque6:boolean;
    primero:string;



//-----------------------------------------------------------------------------------------------------------------------------------

procedure ArranqueDefault;
begin
Iniciar:=false;
form1.Timer1.Interval:=30;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure setear;
var Celeste, Marron ,GrisClaro : TColor;
begin
Celeste:=TColor(RGB(133, 205, 228));   //genero un color celeste personalizado para el fondo del juego
GrisClaro:=TColor(RGB(189,189,189));   //genero un color gris personalizado para el fondo del juego
Marron:=TColor(RGB(202, 147, 82));     //genero un color marron personalizado para el fondo del juego
With form1.Image1 do begin
                     width:=AnchoImagen;  //seteo el ancho del fondo
                     height:=AltoImagen;  //seteo el alto del fondo
                     left:=0;
                     top:=0;
                     end;
With form1.Image1.Canvas do begin
                            //cambio el color a negro del componente "pincel" del canvas
                            Brush.Color:=clblack;
                            //genero un fondo negro para trabajar desde esa base
                            FillRect(Rect(Point(0,0),Point(AnchoImagen,AltoImagen)));
                            //cambio el color a celeste del componente "pincel" del canvas utilizando mi ya creado color personalizado
                            Brush.Color:=Celeste;
                            //dibujo un rectángulo que se corresponde con el fondo del juego
                            FillRect(Rect(Point(0,0),Point(AnchoImagen,AltoCielo)));
                            //cambio el color a marron del componente "pincel" del canvas utilizando mi ya creado color personalizado
                            Brush.Color:=Marron;
                            //dibujo un polígono cuyos puntos representan la arena del lado izquierdo
                            Polygon([Point(0, AltoCielo), Point(0, AltoImagen), Point(AnchoImagen div 2, AltoCielo)]);
                            //dibujo un polígono cuyos puntos representan la arena del lado derecho
                            Polygon([Point(AnchoImagen div 2,AltoCielo),Point(AnchoImagen,AltoImagen),Point(AnchoImagen,AltoCielo)]);
                            //cambio el color a gris del componente "pincel" del canvas utilizando mi ya creado color personalizado
                            Brush.Color:=GrisClaro;
                            //dibujo un polígono cuyos puntos representan la ruta
                            Polygon([Point(AnchoImagen div 2, AltoCielo), Point(0, AltoImagen), Point(AnchoImagen, AltoImagen)]);
                            end;
//le indico al form1 que se acople al tamaño del image1
form1.AutoSize:=true;
end;

//-----------------------------------------------------------------------------------------------------------------------------------
{este procedimiento inicializa el auto, cargando del archivo del tipo bitmap (.bmp) el mapa de bits que conforman el autito
lo coloca en el lugar deseado (centro de la ruta) y le asigna las dimensiones adecuadas para su proporcionalidad en cuanto a el fondo}
procedure dibujarAutito;
begin
with form1.Auto do begin
                   Picture.LoadFromFile('Auto1.bmp');
                   AutoSize:=false;
                   Center:=true;
                   Stretch:=true;
                   Height:=AltoAuto;
                   Width:=AnchoAuto;
                   Left:=CentroJugador1;
                   Top:=AlturaJugador1;
                   end;

end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure dibujarNube;
begin
form1.Nube.Picture.LoadFromFile('Nubes.bmp');
form1.Nube.AutoSize:=false;
form1.Nube.Center:=true;
form1.Nube.Stretch:=true;
form1.Nube.Height:=AltoNube;
form1.Nube.Width:=AnchoNube;
form1.Nube.Left:=1;
form1.Nube.Top:=AltoCielo div 3;
form1.Nube.Visible:=true;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure dibujarObjeto(TipoObj:integer; LadoArranque:integer);
begin
If TipoObj=1 then begin
                  If LadoArranque=1 then begin
                                         with form1.Objeto do begin
                                                              Picture.LoadFromFile('Cactus.bmp');
                                                              AutoSize:=false;
                                                              Center:=true;
                                                              Stretch:=true;
                                                              Height:=AltoCactusInicial;
                                                              Width:=AnchoCactusInicial;
                                                              Left:=(AnchoImagen div 2 ) + 50;
                                                              Top:=AltoCielo+30;
                                                              end;
                                         end
                                    else begin
                                         with form1.Objeto do begin
                                                              Picture.LoadFromFile('Cactus.bmp');
                                                              AutoSize:=false;
                                                              Center:=true;
                                                              Stretch:=true;
                                                              Height:=AltoCactusInicial;
                                                              Width:=AnchoCactusInicial;
                                                              Left:=(AnchoImagen div 2 ) - 75;
                                                              Top:=AltoCielo+30;
                                                              end;
                                         end;
                  end
              else begin
                   If LadoArranque=1 then begin
                                          with form1.Objeto do begin
                                                               Picture.LoadFromFile('Piedra.bmp');
                                                               AutoSize:=false;
                                                               Center:=true;
                                                               Stretch:=true;
                                                               Height:=AltoCactusInicial;
                                                               Width:=AnchoCactusInicial;
                                                               Left:=(AnchoImagen div 2 ) + 50;
                                                               Top:=AltoCielo+30;
                                                               end;
                                          end
                                     else begin
                                          with form1.Objeto do begin
                                                               Picture.LoadFromFile('Piedra.bmp');
                                                               AutoSize:=false;
                                                               Center:=true;
                                                               Stretch:=true;
                                                               Height:=AltoCactusInicial;
                                                               Width:=AnchoCactusInicial;
                                                               Left:=(AnchoImagen div 2 ) - 75;
                                                               Top:=AltoCielo+30;
                                                               end;
                                          end;
                   end;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure primeraCreacion;
var i:integer;
begin
for i:=1 to NEnemigosPosibles do begin
                                 //creacion
                                 enemigo[i]:=timage.create(form1);
                                 enemigo[i].Parent:=form1;
                                 case i of
                                        1: enemigo[i].Picture.LoadFromFile('AutoRojo.bmp');
                                        2: enemigo[i].Picture.LoadFromFile('AutoLila.bmp');
                                        3: enemigo[i].Picture.LoadFromFile('AutoCeleste.bmp');
                                        4: enemigo[i].Picture.LoadFromFile('AutoAmarillo.bmp');
                                        5: enemigo[i].Picture.LoadFromFile('AutoVerde.bmp');
                                        6: enemigo[i].Picture.LoadFromFile('AutoRosa.bmp');
                                 end;
                                 with enemigo[i] do begin
                                                    Anchors:=[akLeft,akTop];
                                                    AutoSize:=false;
                                                    Center:=true;
                                                    Stretch:=true;
                                                    Height:=AltoInicial;
                                                    Width:=AnchoInicial;
                                                    case i of
                                                    1: begin
                                                       Left:=(CentroRuta-15)-(AltoInicial div 2);
                                                       Top:=AltoCielo+30;
                                                       Visible:=false;
                                                       transparent:=true;
                                                       end;
                                                    2: begin
                                                       Left:=CentroRuta-(AltoInicial div 2);
                                                       Top:=AltoCielo+30;
                                                       Visible:=false;
                                                       transparent:=true;
                                                       end;
                                                    3: begin
                                                       Left:=(CentroRuta+15)-(AltoInicial div 2);
                                                       Top:=AltoCielo+30;
                                                       Visible:=false;
                                                       transparent:=true;
                                                       end;
                                                    4: begin
                                                       Left:=(CentroRuta-15)-(AltoInicial div 2);
                                                       Top:=AltoCielo+30;
                                                       Visible:=false;
                                                       transparent:=true;
                                                       end;
                                                    5: begin
                                                       Left:=CentroRuta-(AltoInicial div 2);
                                                       Top:=AltoCielo+30;
                                                       Visible:=false;
                                                       transparent:=true;
                                                       end;
                                                    6: begin
                                                       Left:=(CentroRuta+15)-(AltoInicial div 2);
                                                       Top:=AltoCielo+30;
                                                       Visible:=false;
                                                       transparent:=true;
                                                       end;
                                                    end;

                                                    end
                                 end;

end;

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

procedure Dinamizar;
begin
//..............PRINCIPIO case autos 1era linea.......................................................................................................................//
case lado1 of 1: begin
                 if (enemigo[1].Top < (AltoImagen - (enemigo[1].height + 5) ) ) then begin
                                                                                     if enemigo[1].Visible=false then enemigo[1].Visible:=true;
                                                                                     if (enemigo[1].top < 460) then enemigo[1].Top:=enemigo[1].Top+3
                                                                                                               else enemigo[1].Top:=enemigo[1].Top+5;
                                                                                     enemigo[1].Left:=enemigo[1].Left-2;
                                                                                     if enemigo[1].Height<AltoAuto then begin
                                                                                                                        enemigo[1].Width:=enemigo[1].Width+1;
                                                                                                                        enemigo[1].Height:=enemigo[1].Height+1;
                                                                                                                        end;
                                                                                     if (enemigo[1].Top>Altocielo+300) then continuarFilaAtras:=true;
                                                                                     if (enemigo[1].Top) > ((AlturaJugador1+25) - AltoAuto ) then choque1:=true;
                                                                                     end
                                                                                else begin
                                                                                     enemigo[1].Visible:=false;
                                                                                     enemigo[1].top:=AltoCielo+30;
                                                                                     enemigo[1].Left:=(CentroRuta-15)-(AltoInicial div 2);
                                                                                     enemigo[1].Width:=AnchoInicial;
                                                                                     enemigo[1].Height:=AltoInicial;
                                                                                     PuntajeJ1:=PuntajeJ1+100;
                                                                                     continuar:=false;
                                                                                     choque1:=false;
                                                                                     end;
                 end;
              2: begin
                 if (enemigo[2].Top < (AltoImagen - (enemigo[2].height + 5) ) ) then begin
                                                                                     if enemigo[2].Visible=false then enemigo[2].Visible:=true;
                                                                                     if (enemigo[2].top < 460) then enemigo[2].Top:=enemigo[2].Top+3
                                                                                                               else enemigo[2].Top:=enemigo[2].Top+5;
                                                                                     enemigo[2].Left:=(AnchoImagen div 2)- ((Enemigo[2].Width) div 2);
                                                                                     if enemigo[2].Height<AltoAuto then begin
                                                                                                                        enemigo[2].Width:=enemigo[2].Width+1;
                                                                                                                        enemigo[2].Height:=enemigo[2].Height+1;
                                                                                                                        end;
                                                                                     if (enemigo[2].Top>Altocielo+300) then continuarFilaAtras:=true;
                                                                                     if (enemigo[2].Top) > ((AlturaJugador1+25) - AltoAuto ) then choque2:=true;
                                                                                     end
                                                                                else begin
                                                                                     enemigo[2].Visible:=false;
                                                                                     enemigo[2].top:=AltoCielo+30;
                                                                                     enemigo[2].Left:=CentroRuta-(AltoInicial div 2);;
                                                                                     enemigo[2].Width:=AnchoInicial;
                                                                                     enemigo[2].Height:=AltoInicial;
                                                                                     PuntajeJ1:=PuntajeJ1+100;
                                                                                     continuar:=false;
                                                                                     choque2:=false;
                                                                                     end;
                 end;
              3: begin
                 if (enemigo[3].Top < (AltoImagen - (enemigo[3].height + 5) ) ) then begin
                                                                                     if enemigo[3].Visible=false then enemigo[3].Visible:=true;
                                                                                     if (enemigo[3].top < 460) then enemigo[3].Top:=enemigo[3].Top+3
                                                                                                               else enemigo[3].Top:=enemigo[3].Top+5;
                                                                                     enemigo[3].Left:=enemigo[3].Left+1;
                                                                                     if enemigo[3].Height<AltoAuto then begin
                                                                                                                        enemigo[3].Width:=enemigo[3].Width+1;
                                                                                                                        enemigo[3].Height:=enemigo[3].Height+1;
                                                                                                                        end;
                                                                                     if (enemigo[3].Top>Altocielo+300) then continuarFilaAtras:=true;
                                                                                     if (enemigo[3].Top) > ((AlturaJugador1+25) - AltoAuto ) then choque3:=true;
                                                                                     end
                                                                                else begin
                                                                                     enemigo[3].Visible:=false;
                                                                                     enemigo[3].top:=AltoCielo+30;
                                                                                     enemigo[3].Left:=(CentroRuta+15)-(AltoInicial div 2);
                                                                                     enemigo[3].Width:=AnchoInicial;
                                                                                     enemigo[3].Height:=AltoInicial;
                                                                                     PuntajeJ1:=PuntajeJ1+100;
                                                                                     continuar:=false;
                                                                                     choque3:=false;
                                                                                     end;
                 end;
              end;
//..............FINAL case autos 1era linea.........................................................................................................................//
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

procedure dinamizar2;
begin
//..............PRINCIPIO case autos 2da linea.......................................................................................................................//
case lado2 of
4: begin
if (enemigo[4].Top < (AltoImagen - (enemigo[4].height + 5) ) )
                                                then begin
                                                     if continuarFilaAtras then begin
                                                                                     if enemigo[4].Visible=false then enemigo[4].Visible:=true;
                                                                                     if (enemigo[4].top < 460) then enemigo[4].Top:=enemigo[4].Top+3
                                                                                                               else enemigo[4].Top:=enemigo[4].Top+5;
                                                                                     enemigo[4].Left:=enemigo[4].Left-2;
                                                                                     if enemigo[4].Height<AltoAuto then begin
                                                                                                                        enemigo[4].Width:=enemigo[4].Width+1;
                                                                                                                        enemigo[4].Height:=enemigo[4].Height+1;
                                                                                                                        end;
                                                                                end;
                                                     if (enemigo[4].Top) > ((AlturaJugador1+25) - AltoAuto ) then choque4:=true;
                                                     end
                                                else begin
                                                     enemigo[4].Visible:=false;
                                                     enemigo[4].top:=AltoCielo+30;
                                                     enemigo[4].Left:=(CentroRuta-15)-(AltoInicial div 2);
                                                     enemigo[4].Width:=AnchoInicial;
                                                     enemigo[4].Height:=AltoInicial;
                                                     PuntajeJ1:=PuntajeJ1+100;
                                                     continuar2:=false;
                                                     choque4:=false;
                                                     end;
   end;
5: begin
if (enemigo[5].Top < (AltoImagen - (enemigo[5].height + 5) ) )
                                                then begin
                                                     if continuarFilaAtras then begin
                                                                                if enemigo[5].Visible=false then enemigo[5].Visible:=true;
                                                                                if (enemigo[5].top < 460) then enemigo[5].Top:=enemigo[5].Top+3
                                                                                                          else enemigo[5].Top:=enemigo[5].Top+5;
                                                                                enemigo[5].Left:=(AnchoImagen div 2)- ((Enemigo[5].Width) div 2);
                                                                                if enemigo[5].Height<AltoAuto then begin
                                                                                                                   enemigo[5].Width:=enemigo[5].Width+1;
                                                                                                                   enemigo[5].Height:=enemigo[5].Height+1;
                                                                                                                   end;
                                                                                end;
                                                     if (enemigo[5].Top) > ((AlturaJugador1+25) - AltoAuto ) then choque5:=true;
                                                     end
                                                else begin
                                                     enemigo[5].Visible:=false;
                                                     enemigo[5].top:=AltoCielo+30;
                                                     enemigo[5].Left:=CentroRuta-(AltoInicial div 2);;
                                                     enemigo[5].Width:=AnchoInicial;
                                                     enemigo[5].Height:=AltoInicial;
                                                     PuntajeJ1:=PuntajeJ1+100;
                                                     continuar2:=false;
                                                     choque5:=false;
                                                     end;
   end;

6: begin
if (enemigo[6].Top < (AltoImagen - (enemigo[6].height + 5) ) )
                                                then begin
                                                     if continuarFilaAtras then begin
                                                                                     if enemigo[6].Visible=false then enemigo[6].Visible:=true;
                                                                                     if (enemigo[6].top < 460) then enemigo[6].Top:=enemigo[6].Top+3
                                                                                                               else enemigo[6].Top:=enemigo[6].Top+5;
                                                                                     enemigo[6].Left:=enemigo[6].Left+1;
                                                                                     if enemigo[6].Height<AltoAuto then begin
                                                                                                                        enemigo[6].Width:=enemigo[6].Width+1;
                                                                                                                        enemigo[6].Height:=enemigo[6].Height+1;
                                                                                                                        end;
                                                                                end;
                                                     if (enemigo[6].Top) > ((AlturaJugador1+25) - AltoAuto ) then choque6:=true;
                                                     end
                                                else begin
                                                     enemigo[6].Visible:=false;
                                                     enemigo[6].top:=AltoCielo+30;
                                                     enemigo[6].Left:=(CentroRuta+15)-(AltoInicial div 2);
                                                     enemigo[6].Width:=AnchoInicial;
                                                     enemigo[6].Height:=AltoInicial;
                                                     PuntajeJ1:=PuntajeJ1+100;
                                                     continuar2:=false;
                                                     choque6:=false;
                                                     end;
   end;
  end;

//..............FINAL case autos 2da linea.........................................................................................................................//
end;
//-----------------------------------------------------------------------------------------------------------------------------------

procedure automatizarNube;
begin
if form1.Nube.Left = 800 then ArranqueNube:=2;
if form1.Nube.Left = 0 then ArranqueNube:=1;
if ArranqueNube=1 then form1.Nube.Left:=form1.Nube.Left+1;
if ArranqueNube=2 then form1.Nube.Left:=form1.Nube.Left-1;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure automatizarObjeto;
begin
If Obj = 1 then begin
                case ladoObj of
                             1: //---Objeto 1 Cactus lado derecho--------------------------------------
                                begin
                                If asigneObj=false then begin
                                                        dibujarObjeto(Obj,ladoObj);
                                                        asigneObj:=true;
                                                        end;
                                if (form1.Objeto.Left) < (AnchoImagen - 140)
                                                then begin
                                                     form1.Objeto.Top:=form1.Objeto.Top+3;
                                                     form1.Objeto.Left:=form1.Objeto.Left+3;
                                                     form1.Objeto.Width:=form1.Objeto.Width+1;
                                                     form1.Objeto.Height:=form1.Objeto.Height+1;
                                                     end
                                                else begin
                                                     ladoObj:=random(2)+1;
                                                     if ladoObj=1 then begin
                                                                       form1.Objeto.Height:=AltoCactusInicial;
                                                                       form1.Objeto.Width:=AnchoCactusInicial;
                                                                       form1.Objeto.Left:=(AnchoImagen div 2 ) + 50;
                                                                       form1.Objeto.Top:=AltoCielo+30;
                                                                       end
                                                                  else begin
                                                                       form1.Objeto.Height:=AltoCactusInicial;
                                                                       form1.Objeto.Width:=AnchoCactusInicial;
                                                                       form1.Objeto.Left:=(AnchoImagen div 2 ) - 75;
                                                                       form1.Objeto.Top:=AltoCielo+30;
                                                                       end;
                                                     Obj:=random(2)+1;
                                                     asigneObj:=false;
                                                     end;
                                end;

                             2: //---Objeto 1 Cactus lado izquierdo--------------------------------------
                                begin
                                If asigneObj=false then begin
                                                        dibujarObjeto(Obj,ladoObj);
                                                        asigneObj:=true;
                                                        end;
                                if (form1.Objeto.Left) > 30
                                                then begin
                                                     form1.Objeto.Top:=form1.Objeto.Top+3;
                                                     form1.Objeto.Left:=form1.Objeto.Left-4;
                                                     form1.Objeto.Width:=form1.Objeto.Width+1;
                                                     form1.Objeto.Height:=form1.Objeto.Height+1;
                                                     end
                                                else begin
                                                     ladoObj:=random(2)+1;
                                                     if ladoObj=1 then begin
                                                                       form1.Objeto.Height:=AltoCactusInicial;
                                                                       form1.Objeto.Width:=AnchoCactusInicial;
                                                                       form1.Objeto.Left:=(AnchoImagen div 2 ) + 50;
                                                                       form1.Objeto.Top:=AltoCielo+30;
                                                                       end
                                                                  else begin
                                                                       form1.Objeto.Height:=AltoCactusInicial;
                                                                       form1.Objeto.Width:=AnchoCactusInicial;
                                                                       form1.Objeto.Left:=(AnchoImagen div 2 ) - 75;
                                                                       form1.Objeto.Top:=AltoCielo+30;
                                                                       end;
                                                     Obj:=random(2)+1;
                                                     asigneObj:=false;
                                                     end;
                                end;


                             end;
                end
          else begin
                case ladoObj of
                             1: //---Objeto 2 piedra lado derecho--------------------------------------
                                begin
                                If asigneObj=false then begin
                                                        dibujarObjeto(Obj,ladoObj);
                                                        asigneObj:=true;
                                                        end;
                                if (form1.Objeto.Left) < (AnchoImagen - 140)
                                                then begin
                                                     form1.Objeto.Top:=form1.Objeto.Top+3;
                                                     form1.Objeto.Left:=form1.Objeto.Left+3;
                                                     form1.Objeto.Width:=form1.Objeto.Width+1;
                                                     form1.Objeto.Height:=form1.Objeto.Height+1;
                                                     end
                                                else begin
                                                     ladoObj:=random(2)+1;
                                                     if ladoObj=1 then begin
                                                                       form1.Objeto.Height:=AltoCactusInicial;
                                                                       form1.Objeto.Width:=AnchoCactusInicial;
                                                                       form1.Objeto.Left:=(AnchoImagen div 2 ) + 50;
                                                                       form1.Objeto.Top:=AltoCielo+30;
                                                                       end
                                                                  else begin
                                                                       form1.Objeto.Height:=AltoCactusInicial;
                                                                       form1.Objeto.Width:=AnchoCactusInicial;
                                                                       form1.Objeto.Left:=(AnchoImagen div 2 ) - 75;
                                                                       form1.Objeto.Top:=AltoCielo+30;
                                                                       end;
                                                     Obj:=random(2)+1;
                                                     asigneObj:=false;
                                                     end;
                                end;

                             2: //---Objeto 2 Cactus lado izquierdo--------------------------------------
                                begin
                                If asigneObj=false then begin
                                                        dibujarObjeto(Obj,ladoObj);
                                                        asigneObj:=true;
                                                        end;
                                if (form1.Objeto.Left) > 30
                                                then begin
                                                     form1.Objeto.Top:=form1.Objeto.Top+3;
                                                     form1.Objeto.Left:=form1.Objeto.Left-4;
                                                     form1.Objeto.Width:=form1.Objeto.Width+1;
                                                     form1.Objeto.Height:=form1.Objeto.Height+1;
                                                     end
                                                else begin
                                                     ladoObj:=random(2)+1;
                                                     if ladoObj=1 then begin
                                                                       form1.Objeto.Height:=AltoCactusInicial;
                                                                       form1.Objeto.Width:=AnchoCactusInicial;
                                                                       form1.Objeto.Left:=(AnchoImagen div 2 ) + 50;
                                                                       form1.Objeto.Top:=AltoCielo+30;
                                                                       end
                                                                  else begin
                                                                       form1.Objeto.Height:=AltoCactusInicial;
                                                                       form1.Objeto.Width:=AnchoCactusInicial;
                                                                       form1.Objeto.Left:=(AnchoImagen div 2 ) - 75;
                                                                       form1.Objeto.Top:=AltoCielo+30;
                                                                       end;
                                                     Obj:=random(2)+1;
                                                     asigneObj:=false;
                                                     end;
                                end;


                             end;
                end

end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure inicializacionChoque;
begin
choque1:=false;
choque2:=false;
choque3:=false;
choque4:=false;
choque5:=false;
choque6:=false;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure MenuPrincipal;
begin
form1.Menu.Left:=0;
form1.Menu.Top:=0;
form1.Menu.Width:=AnchoImagen;
form1.Menu.Height:=AltoImagen;
form1.Menu.Picture.LoadFromFile('Menu.bmp');
form1.Menu.AutoSize:=true;
form1.Menu.Center:=true;
form1.Menu.Stretch:=true;
form1.ApagarMusica.Enabled:=false;
form1.Highscores.Enabled:=false;
form1.Creditos.Enabled:=false;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure setearScore;
begin
form1.ScoreBar.Picture.LoadFromFile('ScoreBar.bmp');
form1.ScoreBar.AutoSize:=false;
form1.ScoreBar.Stretch:=true;
form1.ScoreBar.Top:=10;
form1.ScoreBar.Left:=700;
form1.ScoreBar.Width:=256;
form1.ScoreBar.Height:=40;
form1.ScoreBar.Transparent:=true;
form1.Score.Left:=835;
form1.Score.Top:=16;
form1.Score.Font.Size:=16;
form1.Score.Font.Name:='MV Boli';
form1.Score.Font.Style:=[fsBold]; //va entre corchetes por que TFontStyles está definido internamente como set of TFontStyle (recordar).
form1.Score.Font.Color:=RGB(255,255,255);
form1.Score.Transparent:=true;
form1.Score.Visible:=true;

end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure ButtonSet;
begin
//---seteo boton jugar--------
form1.Jugar.Caption:='';
form1.Jugar.Height:=132;
form1.Jugar.Width:=403;
form1.Jugar.Left:=297;
form1.Jugar.Top:=152;
form1.Jugar.Transparent:=true;
//---seteo boton opciones-----
form1.Opciones.Caption:='';
form1.Opciones.Height:=132;
form1.Opciones.Width:=403;
form1.Opciones.Left:=297;
form1.Opciones.Top:=329;
form1.Opciones.Transparent:=true;
//---seteo boton salir--------
form1.Salir.Caption:='';
form1.Salir.Height:=132;
form1.Salir.Width:=403;
form1.Salir.Left:=297;
form1.Salir.Top:=509;
form1.Salir.Transparent:=true;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure textSetHighscore;
var f1:textfile;
    s:string;
begin
form1.ScoreAltoActual.Left:=420;
form1.ScoreAltoActual.Top:=377;
form1.ScoreAltoActual.Height:=40;
form1.ScoreAltoActual.Font.Size:=16;
form1.ScoreAltoActual.Font.Name:='MV Boli';
form1.ScoreAltoActual.Font.Style:=[fsBold]; //va entre corchetes por que TFontStyles está definido internamente como set of TFontStyle (recordar).
form1.ScoreAltoActual.Font.Color:=clwhite;
assignFile(f1,'Score.txt');
reset(f1);
while not EOF(f1) do begin
                     readln(f1,s);
                     end;
closeFile(f1);
form1.ScoreAltoActual.Caption:=''+s+' ';
form1.ScoreAltoActual.Visible:=false;
form1.ScoreAltoActual.Transparent:=true;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure ButtonSetAtrasOpciones;
begin
//---seteo boton Atras opciones -> Menu--------
form1.AtrasOpcionesAMenu.Caption:='';
form1.AtrasOpcionesAMenu.Height:=87;
form1.AtrasOpcionesAMenu.Width:=79;
form1.AtrasOpcionesAMenu.Left:=15;
form1.AtrasOpcionesAMenu.Top:=7;
form1.AtrasOpcionesAMenu.Transparent:=true;
form1.AtrasOpcionesAMenu.Enabled:=false;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure ButtonSetAtrasCreditos;
begin
//---seteo boton Atras Creditos -> Opciones--------
form1.AtrasCreditosAOpciones.Caption:='';
form1.AtrasCreditosAOpciones.Height:=87;
form1.AtrasCreditosAOpciones.Width:=79;
form1.AtrasCreditosAOpciones.Left:=15;
form1.AtrasCreditosAOpciones.Top:=7;
form1.AtrasCreditosAOpciones.Transparent:=true;
form1.AtrasCreditosAOpciones.Enabled:=false;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure ButtonSetAtrasHighscores;
begin
//---seteo boton Atras Highscores -> Opciones--------
form1.AtrasHighscoresAOpciones.Caption:='';
form1.AtrasHighscoresAOpciones.Height:=87;
form1.AtrasHighscoresAOpciones.Width:=79;
form1.AtrasHighscoresAOpciones.Left:=15;
form1.AtrasHighscoresAOpciones.Top:=7;
form1.AtrasHighscoresAOpciones.Transparent:=true;
form1.AtrasHighscoresAOpciones.Enabled:=false;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure ButtonSetOpciones;
begin
//---seteo boton jugar--------
form1.ApagarMusica.Caption:='';
form1.ApagarMusica.Height:=132;
form1.ApagarMusica.Width:=403;
form1.ApagarMusica.Left:=297;
form1.ApagarMusica.Top:=152;
form1.ApagarMusica.Transparent:=true;

//---seteo boton opciones-----
form1.Highscores.Caption:='';
form1.Highscores.Height:=132;
form1.Highscores.Width:=403;
form1.Highscores.Left:=297;
form1.Highscores.Top:=329;
form1.Highscores.Transparent:=true;
//---seteo boton salir--------
form1.Creditos.Caption:='';
form1.Creditos.Height:=132;
form1.Creditos.Width:=403;
form1.Creditos.Left:=297;
form1.Creditos.Top:=509;
form1.Creditos.Transparent:=true;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure OpcionesAMenu;
begin
form1.ApagarMusica.Enabled:=false;
form1.Highscores.Enabled:=false;
form1.Creditos.Enabled:=false;
form1.Menu.Picture.LoadFromFile('Menu.bmp');
form1.Jugar.Enabled:=true;
form1.Opciones.Enabled:=true;
form1.Salir.Enabled:=true;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure CreditosAOpciones;
begin
form1.ApagarMusica.Enabled:=true;
form1.Highscores.Enabled:=true;
form1.Creditos.Enabled:=true;
form1.Menu.Picture.LoadFromFile('MenuOpciones.bmp');
form1.Jugar.Enabled:=false;
form1.Opciones.Enabled:=false;
form1.Salir.Enabled:=false;
form1.AtrasCreditosAOpciones.Enabled:=false;
form1.AtrasHighscoresAOpciones.enabled:=false;
form1.AtrasOpcionesAMenu.Enabled:=true;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure HighscoresAOpciones;
begin
form1.ApagarMusica.Enabled:=true;
form1.Highscores.Enabled:=true;
form1.Creditos.Enabled:=true;
form1.Menu.Picture.LoadFromFile('MenuOpciones.bmp');
form1.Jugar.Enabled:=false;
form1.Opciones.Enabled:=false;
form1.Salir.Enabled:=false;
form1.AtrasCreditosAOpciones.Enabled:=false;
form1.AtrasHighscoresAOpciones.enabled:=false;
form1.AtrasOpcionesAMenu.Enabled:=true;
form1.ScoreAltoActual.Visible:=false;
end;


//-----------------------------------------------------------------------------------------------------------------------------------

procedure TForm1.JugarClick(Sender: TObject);
begin
Setear;
dibujarAutito;
Iniciar:=true;
primeraCreacion;
form1.Menu.Visible:=false;
SetearScore;
dibujarNube;
Obj:=random(2)+1;
ladoObj:=random(2)+1;
asigneObj:=false;
continuar:=false;
continuar2:=false;
continuarFilaAtras:=false;
randomize;
choque:=false;
inicializacionChoque;
form1.wmp2.URL := 'efectogiro.mp3';
form1.wmp2.controls.pause;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure TForm1.OpcionesClick(Sender: TObject);
begin
form1.ApagarMusica.Enabled:=true;
form1.Highscores.Enabled:=true;
form1.Creditos.Enabled:=true;
form1.Menu.Picture.LoadFromFile('MenuOpciones.bmp');
form1.Jugar.Enabled:=false;
form1.Opciones.Enabled:=false;
form1.Salir.Enabled:=false;
form1.AtrasOpcionesAMenu.Enabled:=true;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure TForm1.SalirClick(Sender: TObject);
begin
form1.Close;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure TForm1.CreditosClick(Sender: TObject);
begin
form1.Menu.Picture.LoadFromFile('MenuCréditos.bmp');
form1.ApagarMusica.Enabled:=false;
form1.Highscores.Enabled:=false;
form1.Creditos.Enabled:=false;
form1.AtrasOpcionesAMenu.enabled:=false;
form1.AtrasHighscoresAOpciones.Enabled:=false;
form1.AtrasCreditosAOpciones.Enabled:=true;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure TForm1.HighscoresClick(Sender: TObject);
begin
form1.Menu.Picture.LoadFromFile('MenuHighScores.bmp');
form1.ApagarMusica.Enabled:=false;
form1.Highscores.Enabled:=false;
form1.Creditos.Enabled:=false;
form1.AtrasOpcionesAMenu.enabled:=false;
form1.AtrasCreditosAOpciones.enabled:=false;
form1.AtrasHighscoresAOpciones.Enabled:=true;
form1.ScoreAltoActual.Visible:=true;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure TForm1.AtrasOpcionesAMenuClick(Sender: TObject);
begin
OpcionesAMenu;
end;


//-----------------------------------------------------------------------------------------------------------------------------------

procedure TForm1.AtrasCreditosAOpcionesClick(Sender: TObject);
begin
CreditosAOpciones;
form1.AtrasOpcionesAMenu.Enabled:=true;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure TForm1.AtrasHighscoresAOpcionesClick(Sender: TObject);
begin
HighscoresAOpciones;
form1.AtrasOpcionesAMenu.Enabled:=true;
end;

//-----------------------------------------------------------------------------------------------------------------------------------
procedure TForm1.ApagarMusicaClick(Sender: TObject);
begin
form1.wmp.close;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure updateScore (var PuntajeJ1:integer);
begin
form1.Score.Caption:=inttostr(PuntajeJ1);
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
if form1.Timer1.Enabled=true then begin
case Key of
            {movimiento y acotacion para no salir de pantalla}
            'a': begin
                 if ( ((form1.Auto.Left)-DesplazamientoJ1) > 0 ) then form1.Auto.Left:=(form1.Auto.Left)-DesplazamientoJ1;
                 form1.wmp2.controls.play;
                 end;
            {misma situación, solo que se añadió la 'A' mayúscula en caso de que el usuario tenga activa las mayúsculas}
            'A': begin
                 if ( ((form1.Auto.Left)-DesplazamientoJ1) > 0 ) then form1.Auto.Left:=(form1.Auto.Left)-DesplazamientoJ1;
                 form1.wmp2.controls.play;
                 end;
            {movimiento y acotacion para no salir de pantalla}
            'd': begin
                 if ( ((form1.Auto.Left)+DesplazamientoJ1) < AnchoRutaJ1 ) then form1.Auto.Left :=(form1.Auto.Left)+DesplazamientoJ1;
                 form1.wmp2.controls.play;
                 end;
            {misma situación, solo que se añadió la 'D' mayúscula en caso de que el usuario tenga activa las mayúsculas}
            'D': begin
                 if ( ((form1.Auto.Left)+DesplazamientoJ1) < AnchoRutaJ1 ) then form1.Auto.Left :=(form1.Auto.Left)+DesplazamientoJ1;
                 form1.wmp2.controls.play;
                 end;
            end;
end;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure MusicaMenu;
begin
form1.wmp.URL := 'MusicaMenu.mp3';
form1.wmp.Visible:=false;
form1.wmp2.Visible:=false;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure updateLevel;
begin
case PuntajeJ1 of
         0..500: form1.Timer1.Interval:=30;
         501..1000: form1.Timer1.Interval:=20;
         1001..2500: form1.Timer1.Interval:=10;
         2501..5000: form1.Timer1.Interval:=5;
         5001..maxint: form1.Timer1.Interval:=1;
         end;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure checkColision;

begin

//prueba de colision entre auto jugador1 y enemigo 1
if choque1 then begin
                if form1.Auto.Left = CentroJugador1-DesplazamientoJ1 then choque:=true;
                end;
//prueba de colision entre auto jugador1 y enemigo 2
if choque2 then begin
                if form1.Auto.Left = CentroJugador1 then choque:=true;
                end;
//prueba de colision entre auto jugador1 y enemigo 3
if choque3 then begin
                if form1.Auto.Left = CentroJugador1+DesplazamientoJ1 then choque:=true;
                end;
//prueba de colision entre auto jugador1 y enemigo 4
if choque4 then begin
                if form1.Auto.Left = CentroJugador1-DesplazamientoJ1 then choque:=true;
                end;
//prueba de colision entre auto jugador1 y enemigo 5
if choque5 then begin
                if form1.Auto.Left = CentroJugador1 then choque:=true;
                end;
//prueba de colision entre auto jugador1 y enemigo 6
if choque6 then begin
                if form1.Auto.Left = CentroJugador1+DesplazamientoJ1 then choque:=true;
                end;
end;


//-----------------------------------------------------------------------------------------------------------------------------------

procedure actualizarHighscores(var prim:string);
var aux:string;
    i,posicion:integer;
    myFile:TextFile;
begin
prim:='';
AssignFile(myFile,'Score.txt');
reset(myFile);
while not EOF(myFILE) do begin
                         readln(myFile,aux);
                         end;

posicion:=pos('-',aux);
for i:=1 to posicion-1 do prim:=prim+aux[i];

if PuntajeJ1>(strtoint(prim)) then begin
                                   ReWrite(myFile);
                                   WriteLn(myFile,(inttostr(PuntajeJ1))+'-'+(form1.EscribirNombre.text));
                                   end;
//showmessage(prim);
closeFile(myFile);
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure setearEscribirNombre;
begin
with form1.EscribirNombre do begin
                             Top:=400;
                             left:=180;
                             height:=30;
                             width:=680;
                             font.Size:=20;
                             text:='Ingrese su nombre de la forma XXXXX (5 caracteres máx)';
                             Visible:=false;
                             end;
end;

//-----------------------------------------------------------------------------------------------------------------------------------
procedure buttonsetGuardarScore;
begin
with form1.GuardarScore do begin
                           top:=450;
                           left:=400;
                           height:=30;
                           width:=200;
                           font.Size:=20;
                           caption:='Guardar Puntaje';
                           visible:=false;
                           end;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

Procedure DespuesDelChoque;
begin
//frena el movimiento
form1.Timer1.Enabled:=false;
//cada clase tiene integrada una función de destruir el objeto devolviendo la memoria utilizada correctamente
//destruyo los objetos
form1.Nube.Destroy;
form1.Objeto.Destroy;
form1.Auto.Destroy;
enemigo[1].Destroy;
enemigo[2].Destroy;
enemigo[3].Destroy;
enemigo[4].Destroy;
enemigo[5].Destroy;
enemigo[6].Destroy;
form1.ScoreBar.Destroy;
//corro el score de lugar
form1.Score.Font.Size:=48;
form1.Score.Font.Color:=clwhite;
form1.Score.Left:=621;
form1.Score.Top:=135;
//muestro el menu de juego terminado
form1.Image1.Picture.LoadFromFile('GameOverMenu.bmp');
form1.EscribirNombre.Visible:=true;
form1.GuardarScore.Visible:=true;
//sonido choque
form1.wmp2.URL:='efectochoque.mp3';
form1.wmp2.controls.play;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure TForm1.GuardarScoreClick(Sender: TObject);
begin
actualizarHighscores(primero);
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
begin
DoubleBuffered:=true;
form1.AutoSize:=true;
setearEscribirNombre;
buttonsetGuardarScore;
score.Visible:=false;
ButtonSet;
MenuPrincipal;
ArranqueDefault;
form1.wmp.Visible:=false;
//---sonido menu---------
MusicaMenu;
//---seteo botones-------
ButtonSetOpciones;
ButtonSetAtrasOpciones;
ButtonSetAtrasCreditos;
ButtonSetAtrasHighscores;
//seteo highscore
textSetHighscore;
//---seteo puntaje------
PuntajeJ1:=0;
ArranqueNube:=1;
end;

//-----------------------------------------------------------------------------------------------------------------------------------

procedure TForm1.Timer1Timer(Sender: TObject);
begin
//---Inicia el movimiento del juego---
if continuar=false  then begin
                         lado1:=random(3)+1; //1 <= lado1 <= 3  ; lado1 e N
                         continuar:=true;
                         end;
if continuar2=false then begin
                         lado2:=4+random(3); //4 <= lado2 <= 6  ; lado2 e N
                         continuar2:=true;
                         end;
If iniciar then Dinamizar;
If continuarFilaAtras then dinamizar2;
updateScore(PuntajeJ1);
automatizarNube;
automatizarObjeto;
updateLevel;
checkColision;
if choque then begin
               if form1.Timer1.Enabled=true then DespuesDelChoque;
               end;
end;

//-------------------------------------------------------------------------------------------------------------------------------------



end.
