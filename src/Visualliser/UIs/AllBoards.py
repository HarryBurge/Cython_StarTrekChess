__authour__ = 'Harry Burge'
__date_created__ = '25/05/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '25/05/2020'

# Imports
from kivy.uix.gridlayout import GridLayout
from src.Visualliser.Tiles import BackgroundColor


# AllBoards
class AllBoards(GridLayout):
    '''
    Holds a bunch of Screens inside a Gridlayout
    '''

    def __init__(self, app, screens, *args, **kwargs):
        '''
        params:-
            app : Visualliser : Object to which spawned this
            screens : (Screen, ...) : Screens to be added
        '''
        super().__init__(*args, **kwargs)

        self.rows = 1

        # Adds a line at start to look better
        self.add_widget(BackgroundColor(app.style['background'], size_hint_x=None, width=10))

        for screen in screens:
            self.add_widget(screen)

            # Adds a line inbetween to look better
            self.add_widget(BackgroundColor(app.style['background'], size_hint_x=None, width=10))


# AllBoards
class AllBoardsH(GridLayout):
    '''
    Holds a bunch of Screens inside a Gridlayout
    '''

    def __init__(self, app, screens, *args, **kwargs):
        '''
        params:-
            app : Visualliser : Object to which spawned this
            screens : (Screen, ...) : Screens to be added
        '''
        super().__init__(*args, **kwargs)

        self.cols = 1

        # Adds a line at start to look better
        self.add_widget(BackgroundColor(app.style['background'], size_hint_y=None, height=10))

        for screen in screens:
            self.add_widget(screen)

            # Adds a line inbetween to look better
            self.add_widget(BackgroundColor(app.style['background'], size_hint_y=None, height=10))