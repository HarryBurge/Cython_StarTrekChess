__authour__ = 'Harry Burge'
__date_created__ = '20/04/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '18/05/2020'

# Imports
import importlib
import copy

from src.Game cimport piece_class
# from bin.Utils.game_util import loops
from src.Game.attack_board_class cimport AttackBoard
# from src.Game cimport attack_board_class


# Map
cdef class Map:
    '''
    Used to read a board/map, into a usable class.
    
    Info:-
        -Map file that is pointed to by path needs to have
        map_array = <array>
        -'@' Means a board poistion that any piece can enter
        -'x' Means it is outside the board and no pieces can enter
        -map_array needs to be 3D so [[[], ...], ...]
        -map_array has to have consistent size just fill up with 'x's if needed
    '''

    def __init__(
        self, str path
    ):
        '''
        params:-
            path : Import path to the map e.g. 
                src.Game.Maps.default_star_trek_map
        '''
        # Import map file, based on path given
        map_file = importlib.import_module(path)

        self._board = map_file.map_array
        self._attackmap = map_file.attack_boards_array

        # Size of (x,y,z)
        self._size = [len(self._board[0][0]), 
                            len(self._board[0]), 
                            len(self._board)]


    # Getters
    cpdef object get_gridpoi(
        self, int x, int y, int z
    ):
        '''
        params:-
            x,y,z : Coordinates of what you want to return
        returns:-
            False|Piece_subclass|str : False if coordinates are out 
                of range else returns the Piece or string in that 
                coords of the boord
        '''
        # Python excepts negative numbers which we don't want
        if x < 0 or y < 0 or z < 0:
            return False
        else:
            try:
                return self._board[z][y][x]
            except IndexError:
                return False

    
    cpdef object get_attack_gridpoi(
        self, int ax, int ay
    ):
        '''
        params:-
            ax,ay : Coordinates of attack board in the 
                attack board map
        returns:-
            False|AttackBoard|int[3] : False if incorrect coords
                else return whats in attack board map
        '''
        # Python excepts negative numbers which we don't want
        if ax < 0 or ay < 0:
            return False
        else:
            try:
                return self._attackmap[ay][ax]
            except IndexError:
                return False


    cpdef list get_all_pieces(
        self
    ):
        '''
        params:-
            None
        returns:-
            [(int[3], Subclass_Piece), ...] : Searchs entire board and 
                returns the coordinates and piece object of the piece found 
        '''
        cdef int x,y,z
        cdef int coord[3]
        cdef list all_pieces
        all_pieces = []

        # for x,y,z in loops(range(self._size[0]), range(self._size[1]), range(self._size[2])):
        for x in range(self._size[0]):
            for y in range(self._size[1]):
                for z in range(self._size[2]):

                    # Check if at x,y,z in board it is a subclass of Piece
                    if issubclass(type(self.get_gridpoi(x,y,z)), piece_class.Piece):
                        coord = [x,y,z]
                        all_pieces.append( (coord, self.get_gridpoi(x,y,z)) )

        return all_pieces

    
    cpdef list get_pieces_search(
        self, bint poisitive, str team=None, object piece_type=None
    ):
        '''
        params:-
            poisitive : Whether you want team and piece to be true or false
            team : Team to look for peices
            piece_type : Subclass_Piece : Piece to search for
        returns:-
            [(int[3], Piece_Subclass), ...] : Searchs entire board
                and returns the coordinates and piece object of the piece found 
        '''
        cdef list pieces
        pieces = []

        cdef int x,y,z
        cdef bint check
        cdef int coord[3]


        # for x,y,z in loops(range(self._size[0]), range(self._size[1]), range(self._size[2])):
        for x in range(self._size[0]):
            for y in range(self._size[1]):
                for z in range(self._size[2]):

                    # Check if at x,y,z in board it is a subclass of Piece and part of team
                    if issubclass(type(self.get_gridpoi(x,y,z)), piece_class.Piece):
                        
                        checks = poisitive

                        if team != None and self.get_gridpoi(x,y,z).team != team:
                            checks = not poisitive
                        if piece_type != None and type(self.get_gridpoi(x,y,z)) != piece_type:
                            checks = not poisitive

                        if checks:
                            coord = [x,y,z]
                            pieces.append( ((coord, self.get_gridpoi(x,y,z))) )

        return pieces


    cpdef list _get_board_array(
        self
    ):
        '''
        params:-
            None
        returns:-
            [[[str|Piece_subclass, ...], ...], ...] : The entire board
        '''
        return self._board


    cpdef list _get_attack_board_array(
        self
    ):
        '''
        params:-
            None
        returns:-
            [[AttackBoard|int[3], ...], ...] : The attack board map
        '''
        return self._attackmap

    
    # Setters
    cpdef bint set_gridpoi(
        self, int x, int y, int z, object piece
    ):
        '''
        params:-
            x,y,z : Coords to be replaced
            piece : str|Piece_subclass|List : List is only really used for 
                visualiser
        returns:-
            None|False : False if the coords are wrong, else None
        '''
        # Python excepts negative numbers which we don't want
        if x < 0 or y < 0 or z < 0:
            return False
        else:
            try:
                self._board[z][y][x] = piece
            except IndexError:
                return False

    
    cpdef bint set_attack_gridpoi(
        self, int ax, int ay, object attackboard
    ):
        '''
        params:-
            ax,ay : Coords in the attack board map
            attackboard : AttackBoard|int[3] : To be placed into attack board map
        '''
        # Python excepts negative numbers which we don't want
        if ax < 0 or ay < 0:
            return False
        else:
            try:
                self._attackmap[ay][ax] = attackboard
            except IndexError:
                return False


    # Funcs
    cpdef object move_piece(
        self, int x1, int y1, int z1, int x2, int y2, int z2
    ):
        '''
        params:-
            x1,y1,z1 : coords of piece to move
            x2,y2,z2 : coords of where to move to
        returns:-
            False|str|Piece_subclass : False if coords are wrong
                else whatever has been removed from the board
        '''
        # Python excepts negative numbers which we don't want
        if x1 < 0 or y1 < 0 or z1 < 0 or x2 < 0 or y2 < 0 or z2 < 0:
            return False

        # Make sure both coords are correct
        elif not(self.get_gridpoi(x1,y1,z1)) or not(self.get_gridpoi(x2,y2,z2)):
            return False

        else:
            taken_piece = self.get_gridpoi(x2,y2,z2)

            # Move coords1 to coords 2
            self.set_gridpoi(x2,y2,z2, self.get_gridpoi(x1,y1,z1))

            # Make coords 1 a free space
            self.set_gridpoi(x1,y1,z1, '@')

            return taken_piece


    cpdef bint move_attack_board(
        self, int ax1, int ay1, int ax2, int ay2
    ):
        '''
        params:-
            ax1,ay1 : coords of attack board to move
            ax2,ay2 : coords of attack board poi to move to
        '''
        cdef int x1,y1,z1,x2,y2,z2
        cdef int dx,dy,dz

        if ax1 < 0 or ay1 < 0 or ax2 < 0 or ay2 < 0:
            return False

        elif not(self.get_attack_gridpoi(ax1, ay1) and self.get_attack_gridpoi(ax2, ay2)):
            return False

        elif not(issubclass(type(self.get_attack_gridpoi(ax1, ay1)), AttackBoard) and type(self.get_attack_gridpoi(ax2, ay2)) == tuple):
            return False

        else:
            # Gets actual board coords
            x1,y1,z1 = self.get_attack_gridpoi(ax1, ay1).get_coords()
            x2,y2,z2 = self.get_attack_gridpoi(ax2, ay2)

            # Moves board in attack map
            self.set_attack_gridpoi(ax2, ay2, self.get_attack_gridpoi(ax1, ay1))
            self.get_attack_gridpoi(ax2, ay2).set_coords(x2,y2,z2)
            self.set_attack_gridpoi(ax1, ay1, (x1,y1,z1))

            # Moves x1,y1,z1 to x2,y2,z2 factoring in the area of attack board
            for dx,dy,dz in self.get_attack_gridpoi(ax2, ay2).get_diffrence_area_coords():
                self.set_gridpoi(x2+dx, y2+dy, z2+dz, self.get_gridpoi(x1+dx, y1+dy, z1+dz))
                self.set_gridpoi(x1+dx, y1+dy, z1+dz, 'x')

    
    #TODO: Can use search all pieces function rather than looping list
    cpdef bint is_in_check(
        self, str team, object king_class
    ):
        '''
        params:-
            team : Team of the king you want to see if in check e.g. White
            king_class : Piece_subclass : The class of king
        returns:-
            bool : True if in check else False
        '''
        cdef list kings_coords, other_teams_validmoves
        kings_coords = []
        other_teams_validmoves = []

        # Search for kings of right team
        for coord, piece in self.get_all_pieces():

            if type(piece) == king_class:
            
                if piece.team == team:
                    kings_coords.append(coord)

                # Due to kings needing to simulate check in valid_move_coords
                # will create a recursion error therefore a none check 
                # tested valid move coords need to be used
                elif piece.team != team:
                            
                    for i in piece.valid_move_coords_untested(
                        self, coord[0], coord[1], coord[2]
                    ):
                        other_teams_validmoves.append(i['coord'])

            # Collects all other teams valid moves
            elif issubclass(type(piece), piece_class.Piece) and piece.team != team:
                
                for i in piece.valid_move_coords(
                    self, coord[0], coord[1], coord[2]
                ):
                    other_teams_validmoves.append(i['coord'])

        # If any king is in a valid move of another enemy unit it is in check
        for coords in kings_coords:
            if coords in other_teams_validmoves:
                return True

        return False


    cpdef bint is_in_checkmate(
        self, str team, object king_class
    ):
        '''
        params:-
            team : Team of the king you want to see if in check e.g. White
            king_class : Piece_subclass : The class of king
        returns:-
            bool : True if in checkmate else False
        '''
        # Checks whether king is in check currently
        if not(self.is_in_check(team, king_class)):
            return False

        cdef list kings_coords, teams_moves
        kings_coords = []
        teams_moves = []

        # Search for kings of right team
        print('----' + str(self.get_all_pieces()))
        for coord, piece in self.get_all_pieces():

            # If king and right team then record where it is and the object itself
            if type(piece) == king_class and piece.team == team:
                kings_coords.append((coord, piece))

            # Record all valid moves of same team
            elif issubclass(type(piece), piece_class.Piece) and piece.team == team:
                
                print(piece.valid_move_coords(self, coord[0], coord[1], coord[2]))
                for i in piece.valid_move_coords(
                    self, coord[0], coord[1], coord[2]
                ):
                    teams_moves.append((coord, i['coord']))

        print(kings_coords)           
        for coord, piece in kings_coords:

            # If king can actually move somewhere
            if piece.valid_move_coords(
                self, coord[0], coord[1], coord[2]
            ) != []:
                return False

            # Does any other move team can make stop the check
            print(teams_moves)
            for p1,p2 in teams_moves:

                simulated_board = copy.deepcopy(self)
                simulated_board.move_piece(
                    p1[0], p1[1], p1[2], p2[0], p2[1], p2[2]
                )

                if not simulated_board.is_in_check(team, king_class):
                    return False

        return True