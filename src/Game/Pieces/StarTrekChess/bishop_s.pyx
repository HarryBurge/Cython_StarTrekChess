__authour__ = 'Harry Burge'
__date_created__ = '16/04/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '15/07/2020'

# Imports
from src.Game cimport piece_class


cdef class Bishop(piece_class.Piece):
    '''
    Class for bishop, inherits code for Piece
    '''

    def __init__(
        self, 
        str img_path='bin/Game/Pieces/imgs/', 
        int value=3, 
        str team='Netural'
    ):
        '''
        params:-
            img_path : Path to the folder where images are stored
            value : Value assigned to the piece
            team : Name of team that the piece is on
        '''
        super().__init__(img_path+team+'-Bishop.png', value, team)


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
        valid_moves = []

        # for dx,dy,dz in loops([-1,1], [-1,1], range(-1,2)):

        cdef int adx[2], ady[2], adz[3]
        cdef int dx, dy, dz

        adx = [-1, 1]
        ady = [-1, 1]
        adz = [-1, 0, 1]

        for dx in adx:
            for dy in ady:
                for dz in adz:
                        
                    for i in self.rec_line_StarTrek(
                        board, x+dx, y+dy, z+dz, dx,dy, []
                    ):
                        if not(i in valid_moves): valid_moves.append(i)

        return valid_moves