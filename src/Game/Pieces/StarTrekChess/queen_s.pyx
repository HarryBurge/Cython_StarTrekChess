__authour__ = 'Harry Burge'
__date_created__ = '16/04/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '19/05/2020'

# Imports
from src.Game cimport piece_class

# Queen
cdef class Queen(piece_class.Piece):
    '''
    Class for queen, inherits code for Piece
    '''

    def __init__(
        self, 
        str img_path='bin/Game/Pieces/imgs/', 
        int value=9, 
        str team='Netural'
    ):
        '''
        params:-
            img_path : Path to the folder where images are stores
            value : Value assigned to the piece
            team : Name of team that the piece is on
        '''
        super().__init__(img_path+team+'-Queen.png', value, team)


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

        # for dx,dy,dz in loops(range(-1,2),range(-1,2),range(-1,2)):

        cdef int dx, dy, dz

        for dx in range(-1, 2):
            for dy in range(-1, 2):
                for dz in range(-1, 2):

                    # Can't test along line of dx, dy == 0 due 
                    # to not being a line
                    if not(dx==0 and dy==0):
                        
                        # Due to being StarTrek movement repeats can come
                        # from this func so needs to be filtered
                        for i in self.rec_line_StarTrek(
                            board, x+dx, y+dy, z+dz, dx,dy,[]
                        ):
                            if not(i in valid_moves):
                                valid_moves.append(i)

        return valid_moves