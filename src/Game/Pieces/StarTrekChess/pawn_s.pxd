from src.Game cimport piece_class

cdef class Pawn(piece_class.Piece):
    cdef public list facing
    cdef public bint moved

    cpdef list valid_move_coords(self, object board, int x, int y, int z)