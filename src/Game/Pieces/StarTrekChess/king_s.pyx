__authour__ = 'Harry Burge'
__date_created__ = '16/04/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '19/05/2020'

# Imports
import copy
from src.Game cimport piece_class
# from src.Utils.game_util import loops


# King
cdef class King(piece_class.Piece):
    '''
    Class for king, inherits code for Piece
    '''

    def __init__(
        self, 
        str img_path='bin/Game/Pieces/imgs/', 
        int value=10000, 
        str team='Netural'
        ):
        '''
        params:-
            img_path : Path to the folder where images are stores
            value : Value assigned to the piece
            team : Name of team that the piece is on
        '''
        super().__init__(img_path+team+'-King.png', value, team)


    cpdef list valid_move_coords(
        self, object board, int x, int y, int z
    ):
        '''
        params:-
            board : Map : Board with respect to
            x,y,z : Coords of piece
        returns:-
            [testedCoord, ...] : List of 
                all moves that can be made from this piece
        '''
        cdef int dx,dy,dz
        cdef object current, simulated_map
        cdef list testable_moves
        testable_moves = []

        # for dx,dy,dz in loops(range(-1,2),range(-1,2),range(-1,2)):
        for dx in range(-1, 2):
            for dy in range(-1, 2):
                for dz in range(-1, 2):

                    if not(dx==0 and dy==0 and dz==0):

                        current = self.test_coord(board, x+dx, y+dy, z+dz)

                        if current != False and current.mv_type != piece_class.mvType.Defending:

                            # Simulates map and if in check then not a untested valid move
                            simulated_map = copy.deepcopy(board)
                            simulated_map.move_piece(x, y, z, x+dx, y+dy, z+dz)

                            if not simulated_map.is_in_check(self.team, type(self)):
                                testable_moves.append([x+dx,y+dy,z+dz])

                        elif current != False and current.mv_type == piece_class.mvType.Defending:
                            testable_moves.append([x+dx,y+dy,z+dz])
        
        # Tests all moves
        cdef list tested_moves
        tested_moves = [self.test_coord(board, i[0], i[1], i[2]) for i in testable_moves]

        return tested_moves


    cpdef list valid_move_coords_untested(
        self, object board, int x, int y, int z
    ):
        '''
        params:-
            board : Map : Board with respect to
            x,y,z : Coords of piece
        returns:-
            [testedCoord, ...] : List of 
                all moves that can be made from this piece, not tested to
                see if in check after the move. This is needed due to
                a recursion error in is_in_checkmate
        '''
        cdef int dx,dy,dz
        cdef list testable_moves
        testable_moves = []

        # for dx,dy,dz in loops(range(-1,2),range(-1,2),range(-1,2)):
        for dx in range(-1, 2):
            for dy in range(-1, 2):
                for dz in range(-1, 2):

                    if not(dx==0 and dy==0 and dz==0):
                        testable_moves.append([x+dx,y+dy,z+dz])
            
        # Tests all moves
        cdef list tested_moves
        tested_moves = [self.test_coord(board, i[0], i[1], i[2]) for i in testable_moves]

        return tested_moves