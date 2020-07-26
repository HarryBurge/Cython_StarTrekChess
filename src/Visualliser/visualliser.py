'''
A class to visualise the game and also take instructions in if feature is enabled.
Class is Visualliser and when run() stops code execution so needs to be threaded.
'''

__authour__ = 'Harry Burge'
__date_created__ = '24/04/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '30/04/2020'


'''
TODO:-

'''

# Imports
import kivy

from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import Screen, ScreenManager, SwapTransition
from kivy.uix.gridlayout import GridLayout
from kivy.uix.floatlayout import FloatLayout
from kivy.uix.button import Button
from kivy.uix.label import Label
from kivy.uix.widget import Widget

# Constants
BCKGRND_CLR = [1,1,1,0.1]
WHITE_FREE = [1,1,1,0.6]
BLACK_FREE = [1,1,1,0.4]

Builder.load_string("""
<UI>:
    cols: 1
    size_hint_x: None
    width: 40

    Button:
        id: up_level
        on_press: app.entire.ids.board.changeLevel(app.entire.ids.board.level - 1, app.board)

    Button:
        id: down_level
        on_press: app.entire.ids.board.changeLevel(app.entire.ids.board.level + 1, app.board)


<Entire>:
    cols: 2

    Board:
        id: board
        on_kv_post: self.build_board(app.board)

    UI:


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
        app.game_controller.clicked(self.gx,self.gy,self.gz)
""")


# Classes
class Visualliser(App):

    def __init__(self, board, game_controller, *args, **kwargs):
        '''
        params:-
            board : Map : board to display
            game_controller : Game_Controller : keeps link to the gamecontroller that controls this
        '''
        super().__init__(*args, **kwargs)

        self.board = board
        self.game_controller = game_controller

    def build(self):
        self.entire = Entire()
        return self.entire

    def update_board(self, board):
        '''
        params:-
            board : Map : takes new board passed and prints onto old one
        '''
        self.board = board

        # all sqaures(buttons) owned by board
        for i in self.entire.ids.board.squares:

            if type(i) != BackgroundColor:
                i.update_square(i.gx, i.gy, i.gz, board.get_gridpoi(i.gx, i.gy, i.gz))


class Entire(GridLayout):
    pass


class UI(GridLayout):
    pass


class Board(ScreenManager):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.level = 0
        self.transition = SwapTransition()

    def build_board(self, board):
        '''
        params:-
            board : Map : will create the the visuals for the board
        '''
        # will hold all squares created by below function for later callback
        self.squares = []

        for z in range(len(board._get_board_array())):

            # creates screen for that level
            level_screen = Screen(name='Level{}'.format(z))

            # holds sqaures in gridlayout for that level
            level_board = GridLayout(rows=len(board._get_board_array()[0]), cols=len(board._get_board_array()[0][0]))

            for y in range(len(board._get_board_array()[0])):
                for x in range(len(board._get_board_array()[0][0])):

                    current = board.get_gridpoi(x,y,z)

                    if current == 'x':
                        temp = BackgroundColor(background_color=BCKGRND_CLR)

                    else:
                        temp = Square(x,y,z)
                        temp.update_square(x,y,z, current)
                    
                    # adds square to squares and to the board for visuals
                    self.squares.append(temp)
                    level_board.add_widget(temp)

            # adds board to the screen and then screen to the screen manager
            level_screen.add_widget(level_board)
            self.add_widget(level_screen)


    def changeLevel(self, num, board):
        '''
        params:-
            num : int : level number to jump to
            board : Map : used to check whether num is to high or low
        '''
        if num >= 0 and num < len(board._get_board_array()):
            self.level = num
            self.current = 'Level' + str(num)


class BackgroundColor(Widget):

    def __init__(self, background_color, *args, **kwargs):
        '''
        params:-
            background_color : [int,int,int,int] : colour of the background
        '''
        super().__init__(*args, **kwargs)

        self.background_color = background_color


class Square(Button):
    
    def __init__(self, gx,gy,gz, *args, **kwargs):
        '''
        params:-
            gx : int : grid x coordinate
            gy : int : grid y coordinate
            gz : int : grid z coordinate
        '''
        super().__init__(*args, **kwargs)

        self.gx = gx
        self.gy = gy
        self.gz = gz

    def update_square(self, gx,gy,gz, gridpoi):
        '''
        params:-
            gx : int : grid x coordinate, used to workout black or white square
            gy : int : grid y coordinate, used to workout black or white square
            gz : int : grid z coordinate
            gridpoi : [str|Piece|Piece_subclass] : updates to this image
        '''

        if gridpoi == 'x':
            self.background_color = BCKGRND_CLR

        else:
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

            else:
                if gx%2 == 0 and gy%2 == 0:
                    self.background_color = BLACK_FREE
                elif gx%2 != 0 and gy%2 == 0:
                    self.background_color = WHITE_FREE
                elif gx%2 == 0 and gy%2 != 0:
                    self.background_color = WHITE_FREE
                else:
                    self.background_color = BLACK_FREE

                if gridpoi != '@':
                    self.background_normal = gridpoi.img_path
                elif gridpoi == '@':
                    self.background_normal = ''



if __name__ == '__main__':
    raise RuntimeError('This code can\'t be ran due to being a class')