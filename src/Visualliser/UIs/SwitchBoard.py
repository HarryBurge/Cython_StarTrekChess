__authour__ = 'Harry Burge'
__date_created__ = '25/05/2020'
__last_updated_by__ = 'Harry Burge'
__last_updated_date__ = '25/05/2020'

# Imports
from kivy.uix.gridlayout import GridLayout
from kivy.uix.screenmanager import ScreenManager, SwapTransition
from kivy.uix.button import Button


# SwitchBoard
class SwitchBoard(GridLayout):
    '''
    Holds a bunch of Screens inside a screen manager an can switch with a UI
    '''

    def __init__(self, app, screens, *args, **kwargs):
        '''
        params:-
            app : Visualliser : The parent of this
            screens : (Screen, ...) : Screens to be added onto the UI
        '''
        super().__init__(*args, **kwargs)

        self.app = app

        self.cols = 1
        self.rows = 2

        self.screen_manager = ScreenManager()
        self.screen_manager.transition = SwapTransition()

        # Add screens to the screen manager
        for screen in screens:
            self.screen_manager.add_widget(screen)

        self.add_widget(self.screen_manager)

        # Add the UI buttons
        ui = GridLayout(rows=1, size_hint_y=None, height=20)

        ui.add_widget(Button(on_press=lambda a: self.switch_screen( str(int(self.screen_manager.current) - 1)) ))
        ui.add_widget(Button(on_press=lambda a: self.switch_screen( str(int(self.screen_manager.current) + 1)) ))

        self.add_widget(ui)


    def switch_screen(self, name):
        '''
        params:-
            name : str : Name of the screen you want to change to
        returns:-
            None : Changes the window to the new board
        '''
        if self.screen_manager.has_screen(name):
            self.screen_manager.current = name