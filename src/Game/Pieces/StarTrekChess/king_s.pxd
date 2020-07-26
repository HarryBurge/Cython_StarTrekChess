from src.Game cimport piece_class

cdef class King(piece_class.Piece):
    cpdef list valid_move_coords(self, object board, int x, int y, int z)
    cpdef list valid_move_coords_untested(self, object board, int x, int y, int z)