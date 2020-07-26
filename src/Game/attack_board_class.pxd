cdef class AttackBoard:
    cdef public int x,y,z
    cdef public str team

    cpdef list get_coords(self)
    cpdef list get_diffrence_area_coords(self)
    cpdef set_coords(self, int x, int y, int z)
    cpdef list valid_move_coords(self, object map, int ax, int ay)