from src.Game cimport piece_class

cdef class Bishop(piece_class.Piece):
    cpdef list valid_move_coords(self, object board, int x, int y, int z)