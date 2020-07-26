__authour__ = 'Harry Burge'
__date_created__ = '29/04/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '18/05/2020'

# Imports
import importlib
import copy

from src.Game cimport map_class, piece_class, attack_board_class


# GameController
cdef class GameController:
    '''
    Is used to read in controlloop files and be able to run them.

    Info:-
        -Control loop files need to have a run function which is a loop
        due to kivy (This is cause of the current visualliser using kivy)
        stopping all execution on run thread.
        -Visualliser needs to have run option
        -Visualliser file needs to have a class Visualliser
        -Visualliser needs to have update_board(<Map>) also needs to be able
        to handle showing valid move coords which comes in the form
        ['M'|'D'|'T', str|Piece_subclass]
    '''

    def __init__(
        self, 
        str id, 
        str controlloop_path, 
        str map_path, 
        str ai_path=None
        ):
        '''
        params:-
            controlloop_path : Import path to the controlloop 
                e.g. bin.ControlLoops.default_star_trek_controlloop_1v1
            map_path : Import path to the map
            ai_path : Import path to the AI
        '''
        # Import specfifc control loop
        self.controlloop = importlib.import_module(controlloop_path).ControlLoop()

        # Create specfic map
        self.map = map_class.Map(map_path)

        # Import AI
        if ai_path == None:
            self.AIController = None
        else:
            self.AIController = importlib.import_module(ai_path).Bot()

        self.visualliser = None

        self.id = id
        self.instructions = []


    # Getters
    cpdef str get_id(self):
        return self.id

    cpdef object get_controlloop(self):
        return self.controlloop

    cpdef object get_map(self):
        return self.map
    
    cpdef object get_visualliser(self):
        if self.visualliser == None:
            return False
        return self.visualliser

    cpdef object get_ai_controller(self):
        if self.AIController == None:
            return False
        return self.AIController

    
    # Setters
    cpdef void set_visualliser(
        self, object visualliser
    ):
        self.visualliser = visualliser


    # Interfaces
    # Map getters
    cpdef object get_gridpoi(
        self, int x, int y, int z
    ):
        return self.get_map().get_gridpoi(x,y,z)

    cpdef object get_attack_gridpoi(
        self, int ax, int ay
    ):
        return self.get_map().get_attack_gridpoi(ax, ay)

    cpdef list get_valid_move_coords(
        self, int x, int y, int z
    ):
        return self.get_gridpoi(x,y,z).valid_move_coords(self.get_map(), x,y,z)
    
    cpdef list get_all_pieces(
        self
    ):
        return self.get_map().get_all_pieces()

    # Map setters
    cpdef object set_gridpoi(
        self, int x, int y, int z, object piece
    ):
        return self.get_map().set_gridpoi(x,y,z, piece)

    cpdef object set_attack_gridpoi(
        self, int ax, int ay, object board
    ):
        return self.get_map().set_attack_gridpoi(ax, ay, board)

    # Map funcs
    cpdef object move_piece(
        self, int x1, int y1, int z1, int x2, int y2, int z2
    ):
        return self.get_map().move_piece(x1,y1,z1, x2,y2,z2)

    cpdef object move_attack_board(
        self, int ax1, int ay1, int ax2, int ay2
    ):
        return self.get_map().move_attack_board(ax1, ay1, ax2, ay2)

    cpdef bint is_in_check(
        self, str team, object king_class
    ):
        return self.get_map().is_in_check(team, king_class)

    cpdef bint is_in_checkmate(
        self, str team, object king_class
    ):
        return self.get_map().is_in_checkmate(team, king_class)

    # Visulliser funcs
    cpdef object update_board(
        self, object board
    ):
        return self.get_visualliser().update_board(self, board)


    # Starter
    cpdef void run(
        self
    ):
        '''
        returns:-
            None : Starts up code execution of the gamecontroller
        '''
        if self.get_ai_controller() == False:
            self.get_controlloop().run(self)
        else:
            self.get_controlloop().run(self, self.get_ai_controller())


    # UI - Passing
    cpdef void clicked(
        self, int x, int y, int z
    ):
        '''
        params:-
            x,y,z : int|str : Grid coordinates clicked on
                (Only used for when you have a UI)
        '''
        print(x,y,z)
        self.instructions.append([x,y,z])


    # Comaparitors
    cpdef bint is_in_valid_moves(
        self, list moves, int x, int y, int z, list mv_type):
        '''
        params:-
            moves : [testedCoord, ...] : Moves to search through
            x,y,z : Coords to search through
            mv_type : [mvType, ...] : If coord and one of mv_type
        returns:-
            bool : True is found in moves and False if not
        '''
        cdef int searchcoord[3]
        searchcoord = [x,y,z]

        for i in moves:
            if i['mv_type'] in mv_type and i['coord'] == searchcoord:
                break
        else:
            return False
        return True


    cpdef bint is_team(
        self, int x, int y, int z, str teams_turn
    ):
        '''
        params:-
            x,y,z : Gridpoi of thing selected
            teams_turn : Teams turn
        returns:-
            bool : True if thing at x,y,z is the same teams as teams_turn
                False otherwise
        '''
        cdef object current
        current = self.get_gridpoi(x,y,z)

        if issubclass(type(current), piece_class.Piece) and \
                                    current.team == teams_turn:
            return True
        return False


    cpdef bint can_move(
        self, int x1, int y1, int z1, int x2, int y2, int z2, str teams_turn
    ):
        '''
        params:-
            x1,y1,z1 : Moving piece
            x2,y2,z2 : Place to move to
            teams_turn : Current teams turn
        returns:-
            bool : True if move can be made else False
        '''
        cdef object current
        current = self.get_gridpoi(x1,y1,z1)

        if issubclass(type(current), piece_class.Piece) and \
                            self.is_in_valid_moves(
                                self.get_valid_move_coords(x1,y1,z1), 
                                x2,y2,z2,
                                [piece_class.mvType.Take, piece_class.mvType.Move]
                            ):
            return True
        return False


    # Funcs
    cpdef bint show_valid_moves(
        self, int x, int y, int z, str teams_turn
    ):
        '''
        params:-
            x,y,z : Coords on board to show valid moves of
            teams_turn : What teams turn is it
        returns:-
            bool : True if its shown the valid moves on the board
                False if its failed due to coords being wrong, not being a piece
                or even a visualliser not exsiting
        '''
        cdef object simulated_map
        cdef list validmoves
        cdef str visualtype
        cdef bint flag

        if self.get_visualliser() != False and \
                        self.is_team(x,y,z, teams_turn):

            simulated_map = copy.deepcopy(self.get_map())
            validmoves = simulated_map.get_gridpoi(x,y,z).valid_move_coords(simulated_map, x,y,z)

            # For all moves change the copied boards coords to have a list that can later be used
            # by a visualliser to show valid move coords
            for i in validmoves:

                flag = False

                if i['mv_type'] == piece_class.mvType.Defending:
                    visualtype = 'D'
                    flag = True

                elif i['mv_type'] == piece_class.mvType.Move:
                    visualtype = 'M'
                    flag = True

                elif i['mv_type'] == 'Take':
                    visualtype = 'T'
                    flag = True

                if flag:
                    simulated_map.set_gridpoi(i['coord'][0], 
                                                i['coord'][1], 
                                                i['coord'][2], 
                                                [visualtype, simulated_map.get_gridpoi(i['coord'][0], 
                                                                                       i['coord'][1], 
                                                                                       i['coord'][2])]
                    )

            # Shows the simulated board
            self.get_visualliser().update_board(self, simulated_map)

            return True

        return False


    cpdef bint do_move(
        self, 
        int x1, int y1, int z1, 
        int x2, int y2, int z2, 
        str teams_turn, 
        list moved_pieces, 
        object king_class
    ):
        '''
        params:-
            x1,y1,z1 : Piece to move
            x2,y2,z2 : Place to move to
            teams_turn : Current teams turn
            moved_pieces : [Piece_subclass, ...] : If Piece needs to have moved set
            king_class : Piece_subclass : The class of piece that acts as king
        returns:-
            bool : True if succsessfully moved, False otherwise
        '''
        cdef object simulated_map

        if self.can_move(x1,y1,z1, x2,y2,z2, teams_turn):

            # Simulate move
            simulated_map = copy.deepcopy(self.get_map())
            simulated_map.move_piece(x1,y1,z1, x2,y2,z2)

            # Can't move if it leads to self check
            if simulated_map.is_in_check(teams_turn, king_class):
                return False

            self.move_piece(x1,y1,z1, x2,y2,z2)

            # If visualliser then update screen
            if self.get_visualliser() != False:
                self.get_visualliser().update_board(self, self.get_map())

            # If the piece is a piece that needs to track if moved
            if type(self.get_gridpoi(x2,y2,z2)) in moved_pieces:
                self.get_gridpoi(x2,y2,z2).moved = True
            
            return True

        return False


    cpdef bint do_attack_board_move(
        self, int ax1, int ay1, int ax2, int ay2, str teams_turn
    ):

        if type(self.get_attack_gridpoi(ax1, ay1)) != attack_board_class.AttackBoard:
            return False
        elif self.get_attack_gridpoi(ax1, ay1).team != teams_turn:
            return False
        elif type(self.get_attack_gridpoi(ax2, ay2)) != tuple:
            return False
        else:
            if not(self.move_attack_board(ax1, ay1, ax2, ay2)):
                return False

            # If visualliser then update screen
            if self.get_visualliser() != False:
                self.get_visualliser().update_board(self, self.get_map())
                
            return True