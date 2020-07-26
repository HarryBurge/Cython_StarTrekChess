__authour__ = 'Harry Burge'
__date_created__ = '15/04/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '19/05/2020'

# Imports
from src.Game cimport piece_class
# from src.Utils.game_util import loops


# Pawn
cdef class Pawn(piece_class.Piece):
    '''
    Class for pawn, inherits code for Piece
    '''
    cdef public list facing
    cdef public bint moved

    def __init__(
        self, 
        list facing, 
        str img_path='bin/Game/Pieces/imgs/', 
        int value=1, 
        str team='Netural'
    ):
        '''
        params:-
            facing : (int, int) : Which way the pawn is facing dx,dy
            img_path : Path to the folder where images are stored
            value : Value assigned to the piece
            team : Name of team that the piece is on
        '''
        super().__init__(img_path+team+'-Pawn.png', value, team)

        self.facing = facing
        self.moved = False


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
        cdef object current
        cdef list moves
        moves = []

        for dz in range(-1,2):
            
            # Forward movements
            current = self.test_coord(board, x+self.facing[0],y+self.facing[1],z+dz)

            if current != False and current['mv_type'] == piece_class.mvType.Move:
                moves.append(current)

            if self.moved == False:

                current = self.test_coord(board, x+self.facing[0]*2,y+self.facing[1]*2,z+dz)

                if current != False and current['mv_type'] == piece_class.mvType.Move:
                    moves.append(current)

            # Taking movements
            # for dx, dy in loops(range(-1,2),range(-1,2)):
            for dx in range(-1,2):
                for dy in range(-1, 2):

                    # Checks whether diffrence between facing and dx,dy is less than 90 degress
                    # And are not equal
                    if sum([i*j for (i, j) in zip(self.facing, [dx,dy])]) > 0 and (dx,dy) != self.facing:

                        current = self.test_coord(board, x+dx,y+dy,z+dz)

                        if current != False and current['mv_type'] == piece_class.mvType.Take:
                            moves.append(current)

        return moves
