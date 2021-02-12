# -*- coding: utf-8 -*-

import subprocess
import os
import sys
import shutil
from msvcrt import getwch

basedir = "\\\\AKIRANAS2\\xtorage\\picture\\sites\\http_sumomo-ch_com"
#subprocess.Popen(['explorer', "\\\\AKIRANAS2\\xtorage\\picture\\sites"])

def search_category(categories_map, key):
    for k, c in categories_map:
        if k == key:
            return c
    else:
        return None

def get_c_fmt():
    terminal_size = shutil.get_terminal_size()
    n_columns = 6 # terminal_size.columns / (max_category_length + 5)
    c_fmt = "%-" + ("%d" % max_category_length) + "s"
    return (n_columns, c_fmt)

def show_categories(categories_map):
    n_columns, c_fmt = get_c_fmt()
    c_str = ""

    i = 0
    for k, c in categories_map:
        c_str += ("%s " + c_fmt + "  ") % (k, c)
        i += 1

        if i >= n_columns:
            print(c_str)
            c_str = ""
            i = 0
    if len(c_str) > 0:
        print(c_str)
        c_str = ""

def show_control():
    _, c_fmt = get_c_fmt()
    print(("O " + c_fmt + 
         "  N " + c_fmt +
         "  D " + c_fmt +
         "  S " + c_fmt + 
         "  F " + c_fmt + 
         "  Q " + c_fmt ) 
         % ("Explorer", "CREATE", "DELETE", "SKIP", "SEARCH", "QUIT"))


def add_category(categories_map, category):
    i = len(categories_map)
    if i < 10:
        categories_map.append((chr(i+48), category))
        #print("%s %s" % (chr(i+48), c))
    elif i < 10+26:
        categories_map.append((chr(i+87), category))
        #print("%s %s" % (chr(i+87), c))
    else:
        print("to many categories - %s" % category)

def open_folder(path):
    subprocess.Popen(['explorer', path])
    print("Open Explorer")

def delete_folder(path):
    print("Deleting ... ", end='')
    try:
        shutil.rmtree(path)
        print("Done")
    except Exception as e:
        print("Failed (%s)" % e)

def search_and_move_folders(basedir, folders, categories_map):
    print('Search ? ', end='')
    word = input()

    hits = []
    for f in folders:
        if word in f:
            print(f)
            hits.append(f)
    if len(hits) == 0:
        print('Not found')
        raise Exception("Not found")

    show_categories(categories_map)
    _, c_fmt = get_c_fmt()
    print(("C " + c_fmt + 
         "  N " + c_fmt +
         "  D " + c_fmt +
         "  Q " + c_fmt ) 
         % ("CANCEL", "CREATE", "DELETE", "QUIT"))

    print("? ", end='')
    a = getwch()

    if a == 'C':
        print("CANCEL")
        raise Exception("CANCEL")
    elif a == 'D':
        for f in hits:
            delete_folder(basedir + "\\" + f)
            folders.remove(f)
    elif a == 'Q':
        print("QUIT")
        sys.exit(0)
    else:
        if a == 'N':
            try:
                c = create_new_folder(basedir, categories_map)
            except Exception as e:
                print(e)
                raise e
        else:
            c = search_category(categories_map, a)
        
        if c:
            print("Moving ... ", end='')
            try:
                for f in hits:
                    move_folder(basedir + "\\" + f, basedir + "\\" + c)
                    folders.remove(f)
            except Exception as e:
                print("Failed (%s)" % e)
                raise e
            print("Done")
        else:
            raise Exception("Do nothing")

    return folders

def create_new_folder(dir, categories_map):
    print("CREATE - Folder name ? ", end='')
    name = input()
    os.mkdir(dir + "\\" + name)
    add_category(categories_map, name)
    return name

def move_folder(src, dst):
    shutil.move(src, dst)

def load_folders(basedir):
    categories = []
    folders = []
    for f in os.listdir(basedir):
        if not os.path.isdir(basedir + "\\" + f):
            continue
        
        if f.isascii():
            categories.append(f)
        else:
            folders.append(f)
    categories.sort()

    categories_map = []
    max_category_length = 0
    for c in categories:
        if max_category_length < len(c):
            max_category_length = len(c)
        add_category(categories_map, c)

    return (folders, categories_map, max_category_length)

###### main ###########################################

try:
    folders, categories_map, max_category_length = load_folders(basedir)
except PermissionError as e:
    print("Failed to load folder - %s" % e)
    sys.exit(1)
    

n = 0
while n < len(folders): 
#for f in folders:
    os.system('clear')
    show_categories(categories_map)
    show_control()
    print("")

    f = folders[n]
    print("%s (%d/%d)" % (f, n+1, len(folders)))

    print("? ", end='')
    a = getwch()
    if a == 'O':
        open_folder(basedir + "\\" + f)
    elif a == 'D':
        delete_folder(basedir + "\\" + f)
        n += 1
    elif a == 'S':
        print("SKIPPED")
        n += 1
    elif a == 'Q':
        print("QUIT")
        break
    elif a == 'F':
        try:
            folders = search_and_move_folders(basedir, folders[n:], categories_map)
            n = 0
        except:
            pass

    else:
        if a == 'N':
            try:
                c = create_new_folder(basedir, categories_map)
            except Exception as e:
                print(e)
                continue
        else:
            c = search_category(categories_map, a)
        
        if c:
            print("%s" % c)
            try:
                move_folder(basedir + "\\" + f, basedir + "\\" + c)
            except Exception as e:
                print(e)

            n += 1