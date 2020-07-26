cdef class Piece:
    cdef public str team
    cdef public int value
    cdef public str img_path

    cpdef list valid_move_coords(self, object board, int x, int y, int z)
    cpdef list rec_line_StarTrek(self, object board, int x, int y, int z, int dx, int dy, list _tested_coords)
    cpdef object test_coord(self, object board, int x, int y, int z)


cdef struct testedCoord:
    int coord[3]
    mvType mv_type

cdef enum mvType:
    Move
    Take
    Defending