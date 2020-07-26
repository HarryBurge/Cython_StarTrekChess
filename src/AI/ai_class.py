__authour__ = 'Harry Burge'
__date_created__ = '20/06/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '20/06/2020'

import copy
from src.Game import piece_class


class AI:

    def __init__(self):
        pass


    def suggest_move(self, board, team):
        pass


    def get_unsafe_pieces_on_team(self, board, team):
        unsafe_pieces = []

        for coords1, piece1 in board.get_pieces_search(True, team):

            unsafe = False

            for coords2, piece2 in board.get_pieces_search(False, team):

                if piece_class.testedCoord(*coords1, 2) in piece2.valid_move_coords(board, *coords2):
                    unsafe = True

            if unsafe:
                unsafe_pieces.append((coords1, piece1))

        return unsafe_pieces


    def get_safe_pieces_on_team(self, board, team):
        unsafe_pieces = self.get_unsafe_pieces_on_team(board, team)
        team_pieces = board.get_pieces_search(True, team)

        safe_pieces = [piece for piece in team_pieces if piece not in unsafe_pieces]
        
        return safe_pieces


    def count_pawns_same_column_on_team(self, board, team, pawn_class):
        count = 0
        pawns = board.get_pieces_search(True, team, pawn_class)

        for coords1, peice1 in pawns:

            found = False

            for coords2, peice2 in pawns:
                if coords2 != coords1 and coords1[0] == coords2[0]: found = True

            if found: count += 1
        
        return count


    def get_attacking_pieces_on_piece(self, board, x,y,z, on_piece):
        attacking_pieces = []

        # All other team pieces
        team_pieces = board.get_pieces_search(True, on_piece.team)
        all_pieces = board.get_all_pieces()
        other_teams_pieces = [i for i in all_pieces if i not in team_pieces]

        for coords, piece in other_teams_pieces:

            valid_moves = piece.valid_move_coords(board, *coords)

            if piece_class.testedCoord(x,y,z, 2) in valid_moves:
                attacking_pieces.append((coords, piece))

        return attacking_pieces


    def get_on_piece_attacking_pieces(self, board, x,y,z, on_piece):
        potential_attacks = []

        valid_moves = on_piece.valid_move_coords(board, x,y,z)
        for move in valid_moves:
            if move['mv_type'] == 2:
                potential_attacks.append((move['coords'], board.get_gridpoi(*move['coords'])))

        return potential_attacks


    def simulate_piece_move(self, board, x1,y1,z1, x2,y2,z2):
        simulated_board = copy.deepcopy(board)
        if simulated_board.move_piece(x1,y1,z1, x2,y2,z2) == False:
            return False
        return simulated_board