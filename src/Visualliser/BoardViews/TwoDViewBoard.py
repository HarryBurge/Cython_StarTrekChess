__authour__ = 'Harry Burge'
__date_created__ = '25/05/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '25/05/2020'

# Imports
from kivy.uix.gridlayout import GridLayout
from kivy.uix.button import Button
from src.Utils.game_util import loops
from src.Visualliser.Tiles import Square


# TwoDViewBoard
class TwoDViewBoard(GridLayout):
    '''
    Holds a grid layout of tiles of a board in a fully 2D view even if board is 3D
    '''

    def __init__(self, app, game_controller, user_interaction, *args, **kwargs):
        super().__init__(*args, **kwargs)
        '''
        params:-
            app : Visualliser : Object that has spawned this one
            game_controller : Game assigned to this board
            user_interaction : bool : True if you want the user to be able to interact with the visuals else False
        '''
        self.cols = 2

        board_grid = GridLayout()

        self.app = app
        self.game_controller = game_controller

        # will hold all squares created by below function for later callback
        self.squares = []

        board_map = game_controller.get_map()

        # Makes a vertical board
        board_grid.cols = board_map._size[0]
        board_grid.rows = board_map._size[1] * board_map._size[2]

        # Loops through all map coords
        for z,y,x in loops(range(board_map._size[2]), range(board_map._size[1]), range(board_map._size[0])):

            current = board_map.get_gridpoi(x,y,z)

            temp = Square(app, game_controller, x,y,z)
            temp.update_square(x,y,z, current)
            self.squares.append(temp)

            board_grid.add_widget(temp)

        self.add_widget(board_grid)


        if user_interaction:
            attack_board_ui = GridLayout()
            attack_board_ui.size_hint_x = None
            attack_board_ui.width = 50

            attack_board_ui.cols = len(board_map._get_attack_board_array()[0])
            attack_board_ui.rows = len(board_map._get_attack_board_array())

            for y, x in loops(range(len(board_map._get_attack_board_array())), range(len(board_map._get_attack_board_array()[0]))):

                temp = Square(app, game_controller, x, y, 'AttackBoard')
                attack_board_ui.add_widget(temp)

            self.add_widget(attack_board_ui)
        

    def update_board(self, board_map):
        '''
        params:-
            board_map : Map : Map of which is respect to
        returns:-
            None
        '''
        # For all squares update them based on new map
        for square in self.squares:

            current = board_map.get_gridpoi(square.gx, square.gy, square.gz)
            square.update_square(square.gx, square.gy, square.gz, current)

            try:
                # Used to get rid of useless lines in the map to make it look a bit cleaner
                if board_map._get_board_array()[square.gz][square.gy] == ['x'] * board_map._size[0] and board_map._get_board_array()[square.gz][square.gy+1] == ['x'] * board_map._size[0]:
                    #If line needs to be minimised
                    square.minimise()
                else:
                    square.maximise()
                    
            except IndexError:
                pass


# TwoDViewBoardH
class TwoDViewBoardH(GridLayout):
    '''
    Holds a grid layout of tiles of a board in a fully 2D view even if board is 3D
    '''

    def __init__(self, app, game_controller, user_interaction, *args, **kwargs):
        super().__init__(*args, **kwargs)
        '''
        params:-
            app : Visualliser : Object that has spawned this one
            game_controller : Game assigned to this board
            user_interaction : bool : True if you want the user to be able to interact with the visuals else False
        '''
        self.rows = 2

        board_grid = GridLayout()

        self.app = app
        self.game_controller = game_controller

        # will hold all squares created by below function for later callback
        self.squares = []

        board_map = game_controller.get_map()

        # Makes a vertical board
        board_grid.rows = board_map._size[0]
        board_grid.cols = board_map._size[1] * board_map._size[2]

        # Loops through all map coords
        for x,z,y in loops(range(board_map._size[0]), range(board_map._size[2]), range(board_map._size[1])):

            current = board_map.get_gridpoi(x,y,z)

            temp = Square(app, game_controller, x,y,z)
            temp.update_square(x,y,z, current)
            self.squares.append(temp)

            board_grid.add_widget(temp)

        self.add_widget(board_grid)


        if user_interaction:
            attack_board_ui = GridLayout()
            attack_board_ui.size_hint_y = None
            attack_board_ui.height = 50

            attack_board_ui.rows = len(board_map._get_attack_board_array()[0])
            attack_board_ui.cols = len(board_map._get_attack_board_array())

            for x,y in loops(range(len(board_map._get_attack_board_array()[0])), range(len(board_map._get_attack_board_array()))):

                temp = Square(app, game_controller, x, y, 'AttackBoard')
                attack_board_ui.add_widget(temp)

            self.add_widget(attack_board_ui)
        

    def update_board(self, board_map):
        '''
        params:-
            board_map : Map : Map of which is respect to
        returns:-
            None
        '''
        # For all squares update them based on new map
        for square in self.squares:

            current = board_map.get_gridpoi(square.gx, square.gy, square.gz)
            square.update_square(square.gx, square.gy, square.gz, current)

            try:
                # Used to get rid of useless lines in the map to make it look a bit cleaner
                if board_map._get_board_array()[square.gz][square.gy] == ['x'] * board_map._size[0] and board_map._get_board_array()[square.gz][square.gy+1] == ['x'] * board_map._size[0]:
                    #If line needs to be minimised
                    square.minimise()
                else:
                    square.maximise()
                    
            except IndexError:
                pass