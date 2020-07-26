__authour__ = 'Harry Burge'
__date_created__ = '15/04/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '14/07/2020'


# Piece
cdef class Piece:
    '''
    Holds super class for all peices. 
    
    Info:-
        -When creating a custom peice, please super this class
        -New pieces need to have a valid_move_coords function
    '''

    def __init__(
        self, str img_path=None, int value=0, str team='Neutral'
    ):
        '''
        Params:-
            img_path : Path to folder containing image for piece based on 
                <team>-<piecename>.png
            value : Value assigned to piece, this is arbitrary
            team : Team of which piece belongs too
        '''
        self.team = team
        self.value = value
        self.img_path = img_path

    
    # Super Class things
    cpdef list valid_move_coords(
        self, object board, int x, int y, int z
    ):
        '''
        Params:-
            board : Map : Board with respect to
            x,y,z : Coords of piece
        Returns:-
            [] : This needs to get overidden by custom pieces
                here just incase some piece doesn't overide
        '''
        return []


    # Funcs
    cpdef list rec_line_StarTrek(
        self, 
        object board, 
        int x, int y, int z, 
        int dx, int dy, 
        list _tested_coords
    ):
        '''
        Params:-
            board : Map : Board of which is respect to
            x,y,z : Coords on board to check on this recursive call
            dx,dy : Recusivly moves along line defined by diffrences
            _tested_coords : [] : Has to be passed in due to acting like a global
        Returns:-
            [testedCoord, ...] : List of all moves that can be made along this line after recursive call has finished. Due to StarTrekChess in mechanice actually being 2D it will also check -+1 dz so duplicate coords will be created in situations like a piece on the line a free space above and below. This needs to be accounted for whilst using this function.
        '''
        cdef int coord[3]
        coord = [x,y,z]

        if coord in _tested_coords:
            return []
        else:
            _tested_coords.append(coord)
            current = self.test_coord(board, x,y,z)

            if not current:
                return []

            temp = []

            if current['mv_type'] == mvType.Move:
                for dz in [-1,0,1]:
                    temp += self.rec_line_StarTrek(board, x+dx, y+dy, z+dz, dx, dy, _tested_coords)

            else:
                for dz in [-1,1]:
                    temp += self.rec_line_StarTrek(board, x, y, z+dz, dx, dy, _tested_coords)

            return [current] + temp


    cpdef object test_coord(
        self, object board, int x, int y, int z
    ):
        '''
        params:-
            board : Map : Board of which respect too
            x,y,z : Coords to test on
        returns:-
            False|testedCoord : Checks whether the peice
                if able to get that coord whether it can due to other entitys.
                Like if they are the same team or not a poistion at all
        '''
        current = board.get_gridpoi(x,y,z)
        cdef int coord[3]
        coord = [x,y,z]

        if not current or current == 'x':
            return False

        elif current == '@':
            return testedCoord(coord, mvType.Move)

        elif issubclass(type(current), Piece):

            if current.team != self.team:
                return testedCoord(coord, mvType.Take) 
            else:
                return testedCoord(coord, mvType.Defending)

        else:
            raise SyntaxError('Invalid object or string in map')