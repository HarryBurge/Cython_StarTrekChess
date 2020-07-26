__authour__ = 'Harry Burge'
__date_created__ = '25/05/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '25/05/2020'

# Imports
from kivy.lang.builder import Builder
from kivy.uix.button import Button
from kivy.uix.widget import Widget

# Canvas (graphics) setting
Builder.load_string("""
<BackgroundColor>:
    background_color: 1,1,1,1

    canvas.before:
        Color:
            rgba: root.background_color
        Rectangle:
            size: self.size
            pos: self.pos


<Square>:
    background_color: 1,1,1,1
    background_normal: ''

    canvas.before:
        Color:
            rgba: root.background_color
        Rectangle:
            size: self.size
            pos: self.pos

    on_press:
        if self.app.user_interaction: self.game_controller.clicked(self.gx,self.gy,self.gz)
""")


# BackgroundColor
class BackgroundColor(Widget):

    def __init__(self, background_color, *args, **kwargs):
        '''
        params:-
            background_color : [int,int,int,int] : colour of the background
        '''
        super().__init__(*args, **kwargs)

        self.background_color = background_color


# Square
class Square(Button):
    
    def __init__(self, app, game_controller, gx,gy,gz, *args, **kwargs):
        '''
        params:-
            gx : int : grid x coordinate
            gy : int : grid y coordinate
            gz : int : grid z coordinate
        '''
        super().__init__(*args, **kwargs)

        self.app = app

        self.gx = gx
        self.gy = gy
        self.gz = gz

        self.game_controller = game_controller

    def minimise(self):
        self.size_hint_y = None
        self.height = 0
        self.size_hint_x = None
        self.width = 0

    def maximise(self):
        self.size_hint_y = 1
        self.size_hint_x = 1

    def update_square(self, gx,gy,gz, gridpoi):
        '''
        params:-
            gx : int : grid x coordinate, used to workout black or white square
            gy : int : grid y coordinate, used to workout black or white square
            gz : int : grid z coordinate
            gridpoi : [str|Piece|Piece_subclass] : updates to this image
        '''
        if gridpoi == 'x':
            self.background_color = self.app.style['background']
            self.background_normal = ''

        else:
            
            # If its a list then it needs to have some sort of overlay to say what
            # is happening to that piece
            if type(gridpoi) == list:
                if gridpoi[0] == 'D':
                    self.background_color = [1,1,0,1]
                elif gridpoi[0] == 'M':
                    self.background_color = [1,0,1,1]
                elif gridpoi[0] == 'T':
                    self.background_color = [0,1,1,1]

                if gridpoi[1] != '@':
                    self.background_normal = gridpoi[1].img_path
                elif gridpoi[1] == '@':
                    self.background_normal = ''

            # If not a list then just do a normal update
            else:
                if gx%2 == 0 and gy%2 == 0:
                    self.background_color = self.app.style['blacktile']
                elif gx%2 != 0 and gy%2 == 0:
                    self.background_color = self.app.style['whitetile']
                elif gx%2 == 0 and gy%2 != 0:
                    self.background_color = self.app.style['whitetile']
                else:
                    self.background_color = self.app.style['blacktile']

                if gridpoi != '@':
                    self.background_normal = gridpoi.img_path
                elif gridpoi == '@':
                    self.background_normal = ''