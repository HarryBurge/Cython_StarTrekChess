__authour__ = 'Harry Burge'
__date_created__ = '10/06/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '10/06/2020'

# Imports
# from bin.Utils.game_util import loops


# Attack board
cdef class AttackBoard:
    '''
    Holds info on an attack board of where it is and which team controls it
    '''

    def __init__(
        self, int x, int y, int z, str team='Neutral'
    ):
        self.x = x
        self.y = y
        self.z = z
        self.team = team


    cpdef list get_coords(
        self
    ):
        cdef list coord
        coord = [self.x, self.y, self.z]
        return coord


    cpdef list get_diffrence_area_coords(
        self
    ):
        cdef int dx, dy, coord[3]
        cdef list area_coords
        area_coords = []

        # for dx, dy in loops([0,1], [0,1]):

        for dx in range(0, 2):
            for dy in range(0, 2):
                coord = [dx, dy, 0]
                area_coords.append(coord)

        return area_coords


    cpdef set_coords(
        self, int x, int y, int z
    ):
        self.x = x
        self.y = y
        self.z = z


    cpdef list valid_move_coords(
        self, object map, int ax, int ay
    ):
        '''
        params:-
            map : Map : Board of which respect to
            ax,ay : Poistion of attack board in the attackmap
        returns:-
            [int[2], ...] : Suitable coords for attack board to be able to move to
        '''
        cdef int dx, dy, coord[2]
        cdef list valid_moves
        valid_moves = []

        # for dx,dy in loops([-1,0,1], [-1,0,1]):
        for dx in range(-1, 2):
            for dy in range(-1, 2):
                if not(dx == dy) and type(map.get_attack_gridpoi(ax+dx, ay+dy)) == tuple:
                    coord = [ax+dx, ay+dy]
                    valid_moves.append(coord)

        return valid_moves
                

