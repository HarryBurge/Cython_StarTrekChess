cdef class Map:
    cdef public list _board
    cdef public list _attackmap
    cdef public int _size[3]

    cpdef object get_gridpoi(self, int x, int y, int z)
    cpdef object get_attack_gridpoi(self, int ax, int ay)
    cpdef list get_all_pieces(self)
    cpdef list get_pieces_search(self, bint poisitive, str team=*, object piece_type=*)
    cpdef list _get_board_array(self)
    cpdef list _get_attack_board_array(self)
    cpdef bint set_gridpoi(self, int x, int y, int z, object piece)
    cpdef bint set_attack_gridpoi(self, int ax, int ay, object attackboard)
    cpdef object move_piece(self, int x1, int y1, int z1, int x2, int y2, int z2)
    cpdef bint move_attack_board(self, int ax1, int ay1, int ax2, int ay2)
    cpdef bint is_in_check(self, str team, object king_class)
    cpdef bint is_in_checkmate(self, str team, object king_class)