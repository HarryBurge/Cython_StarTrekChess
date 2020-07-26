__authour__ = 'Harry Burge'
__date_created__ = '16/04/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '19/05/2020'

# Imports
from src.Game cimport piece_class
# from src.Utils.game_util import loops


# Castle
cdef class Castle(piece_class.Piece):
    '''
    Class for castle, inherits code for Piece
    '''

    def __init__(
        self, 
        str img_path='bin/Game/Pieces/imgs/', 
        int value=5, 
        str team='Netural'
    ):
        '''
        params:-
            img_path : Path to the folder where images are stores
            value : Value assigned to the piece
            team : Name of team that the piece is on
        '''
        super().__init__(img_path+team+'-Castle.png', value, team)


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
        cdef int dz, d
        cdef list valid_moves
        valid_moves = []

        # for dz, d in loops(range(-1,2), [-1, 1]):
        for dz in range(-1, 2):
            for d in [-1, 1]:

                # Checks along dx
                for i in self.rec_line_StarTrek(board, x+d, y, z+dz, d,0, []):
                    if not(i in valid_moves):
                        valid_moves.append(i)

                # Checks along dy
                for i in self.rec_line_StarTrek(board, x, y+d, z+dz, 0,d, []):
                    if not(i in valid_moves):
                        valid_moves.append(i)

        return valid_moves