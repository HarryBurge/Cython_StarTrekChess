def loops(*args, values=[]):

    if args == ():
        return [values]

    else:
        temp = []
        
        for i in args[0]:
            temp += loops(*args[1:], values=values + [i])

        return temp


def normalise(value, maxv, minv):
    return (value - minv)/(maxv - minv)