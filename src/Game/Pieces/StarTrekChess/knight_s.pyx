__authour__ = 'Harry Burge'
__date_created__ = '16/04/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '15/07/2020'

# Imports
from src.Game cimport piece_class


# Knight
cdef class Knight(piece_class.Piece):
    '''
    Class for knight, inherits code for Piece
    '''

    def __init__(
        self, 
        str img_path='bin/Game/Pieces/imgs/', 
        int value=3, 
        str team='Netural'
    ):
        '''
        params:-
            img_path : Path to the folder where images are stores
            value : Value assigned to the piece
            team : Name of team that the piece is on
        '''
        super().__init__(img_path+team+'-Knight.png', value, team)


    cpdef list valid_move_coords(
        self, object board, int x, int y, int z
    ):
        '''
        params:-
            board : Map : Board with respect to
            x,y,z : Coords of piece
        returns:-
            [testedCoord, ...] : List of all moves that can be 
                made from this piece
        '''
        cdef list testable_moves = []

        cdef int adz[3], ad1[2], ad2[2], coord[3]
        cdef int dx, dy, dz

        adz = [-1, 0, 1]
        ad1 = [-1, 1]
        ad2 = [-2, 2]

        for dz in adz:

            # Creates all moves that horse could create on x axis
            for dx in ad2:
                for dy in ad1:
                    coord = [x+dx,y+dy,z+dz]
                    testable_moves.append(coord)

            # Creates all moves that horse could create on y axis
            for dx in ad1:
                for dy in ad2:
                    coord = [x+dx,y+dy,z+dz]
                    testable_moves.append(coord)

        cdef list tested_moves
        tested_moves = [self.test_coord(board, i[0], i[1], i[2]) for i in testable_moves]

        return tested_moves