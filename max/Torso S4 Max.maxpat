{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 9,
      "minor": 2,
      "revision": 0,
      "architecture": "x64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      72,
      62,
      1050,
      735
    ],
    "bgcolor": [
      0.073,
      0.081,
      0.088,
      1
    ],
    "editing_bgcolor": [
      0.18,
      0.2,
      0.22,
      1
    ],
    "openinpresentation": 1,
    "gridsize": [
      15.0,
      15.0
    ],
    "default_fontsize": 12.0,
    "default_fontname": "Arial",
    "boxes": [
      {
        "box": {
          "id": "obj-1",
          "maxclass": "comment",
          "patching_rect": [
            28,
            25,
            156,
            26
          ],
          "varname": "title",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            16,
            13,
            159,
            27
          ],
          "text": "TORSO  /  S-4",
          "fontsize": 19,
          "fontname": "Arial",
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1
          ]
        }
      },
      {
        "box": {
          "id": "obj-2",
          "maxclass": "comment",
          "patching_rect": [
            200,
            25,
            70,
            22
          ],
          "varname": "out_label",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            192,
            18,
            72,
            18
          ],
          "text": "MIDI OUT",
          "fontsize": 11,
          "fontname": "Arial",
          "textcolor": [
            0.65,
            0.7,
            0.73,
            1
          ]
        }
      },
      {
        "box": {
          "id": "obj-3",
          "maxclass": "umenu",
          "patching_rect": [
            270,
            25,
            198,
            25
          ],
          "varname": "destination_menu",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "int",
            "",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            267,
            14,
            222,
            26
          ],
          "items": [
            "No MIDI output"
          ],
          "bgcolor": [
            0.137,
            0.155,
            0.168,
            1
          ],
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "fontsize": 12,
          "fontname": "Arial"
        }
      },
      {
        "box": {
          "id": "obj-4",
          "maxclass": "textbutton",
          "patching_rect": [
            472,
            25,
            58,
            25
          ],
          "varname": "refresh_button",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            494,
            14,
            62,
            26
          ],
          "text": "Refresh",
          "texton": "Refresh",
          "mode": 0,
          "outputmode": 1,
          "bgcolor": [
            0.137,
            0.155,
            0.168,
            1
          ],
          "bgoncolor": [
            0.95,
            0.66,
            0.45,
            1
          ],
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "textoncolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "textovercolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "usetextovercolor": 0,
          "rounded": 6,
          "fontsize": 12,
          "fontname": "Arial"
        }
      },
      {
        "box": {
          "id": "obj-5",
          "maxclass": "textbutton",
          "patching_rect": [
            535,
            25,
            60,
            25
          ],
          "varname": "play_button",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "int",
            "",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            574,
            14,
            60,
            26
          ],
          "text": "Play",
          "texton": "Stop",
          "mode": 1,
          "outputmode": 1,
          "bgcolor": [
            0.65,
            0.91,
            0.58,
            1
          ],
          "bgoncolor": [
            0.95,
            0.66,
            0.45,
            1
          ],
          "textcolor": [
            0.073,
            0.13,
            0.08,
            1
          ],
          "textoncolor": [
            0.073,
            0.13,
            0.08,
            1
          ],
          "textovercolor": [
            0.073,
            0.13,
            0.08,
            1
          ],
          "usetextovercolor": 0,
          "rounded": 6,
          "fontsize": 12,
          "fontname": "Arial"
        }
      },
      {
        "box": {
          "id": "obj-6",
          "maxclass": "comment",
          "patching_rect": [
            600,
            25,
            40,
            22
          ],
          "varname": "bpm_label",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            648,
            18,
            35,
            18
          ],
          "text": "BPM",
          "fontsize": 11,
          "fontname": "Arial",
          "textcolor": [
            0.65,
            0.7,
            0.73,
            1
          ]
        }
      },
      {
        "box": {
          "id": "obj-7",
          "maxclass": "flonum",
          "patching_rect": [
            643,
            25,
            57,
            25
          ],
          "varname": "bpm_number",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "bang"
          ],
          "presentation": 1,
          "presentation_rect": [
            686,
            14,
            61,
            26
          ],
          "minimum": 20.0,
          "maximum": 300.0,
          "format": 6,
          "numdecimalplaces": 1,
          "bgcolor": [
            0.137,
            0.155,
            0.168,
            1
          ],
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "fontsize": 12
        }
      },
      {
        "box": {
          "id": "obj-8",
          "maxclass": "textbutton",
          "patching_rect": [
            715,
            25,
            96,
            25
          ],
          "varname": "open_button",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            829,
            14,
            84,
            26
          ],
          "text": "Open Project",
          "texton": "Open Project",
          "mode": 0,
          "outputmode": 1,
          "bgcolor": [
            0.137,
            0.155,
            0.168,
            1
          ],
          "bgoncolor": [
            0.95,
            0.66,
            0.45,
            1
          ],
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "textoncolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "textovercolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "usetextovercolor": 0,
          "rounded": 6,
          "fontsize": 12,
          "fontname": "Arial"
        }
      },
      {
        "box": {
          "id": "obj-9",
          "maxclass": "textbutton",
          "patching_rect": [
            820,
            25,
            96,
            25
          ],
          "varname": "save_button",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            920,
            14,
            84,
            26
          ],
          "text": "Save Project",
          "texton": "Save Project",
          "mode": 0,
          "outputmode": 1,
          "bgcolor": [
            0.137,
            0.155,
            0.168,
            1
          ],
          "bgoncolor": [
            0.95,
            0.66,
            0.45,
            1
          ],
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "textoncolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "textovercolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "usetextovercolor": 0,
          "rounded": 6,
          "fontsize": 12,
          "fontname": "Arial"
        }
      },
      {
        "box": {
          "id": "obj-10",
          "maxclass": "textbutton",
          "patching_rect": [
            975,
            25,
            75,
            25
          ],
          "varname": "record_window_button",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            754,
            14,
            67,
            26
          ],
          "text": "USB Rec",
          "texton": "USB Rec",
          "mode": 0,
          "outputmode": 1,
          "bgcolor": [
            0.137,
            0.155,
            0.168,
            1
          ],
          "bgoncolor": [
            0.95,
            0.66,
            0.45,
            1
          ],
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "textoncolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "textovercolor": [
            0.93,
            0.95,
            0.96,
            1
          ],
          "usetextovercolor": 0,
          "rounded": 6,
          "fontsize": 12,
          "fontname": "Arial"
        }
      },
      {
        "box": {
          "id": "obj-11",
          "maxclass": "comment",
          "patching_rect": [
            35,
            392,
            720,
            22
          ],
          "varname": "status_display",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            16,
            652,
            980,
            20
          ],
          "text": "Choose a MIDI output",
          "fontsize": 11,
          "fontname": "Arial",
          "textcolor": [
            0.65,
            0.7,
            0.73,
            1
          ]
        }
      },
      {
        "box": {
          "id": "obj-12",
          "maxclass": "v8ui",
          "patching_rect": [
            33,
            436,
            1020,
            590
          ],
          "varname": "surface",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            51,
            1020,
            590
          ],
          "filename": "s4-ui.js",
          "border": 0,
          "background": 0
        }
      },
      {
        "box": {
          "id": "obj-13",
          "maxclass": "newobj",
          "patching_rect": [
            475,
            66,
            43,
            22
          ],
          "varname": "refresh",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "t b b"
        }
      },
      {
        "box": {
          "id": "obj-14",
          "maxclass": "newobj",
          "patching_rect": [
            316,
            97,
            58,
            22
          ],
          "varname": "info",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "midiinfo"
        }
      },
      {
        "box": {
          "id": "obj-15",
          "maxclass": "newobj",
          "patching_rect": [
            316,
            132,
            72,
            22
          ],
          "varname": "route_clear",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "text": "route clear"
        }
      },
      {
        "box": {
          "id": "obj-16",
          "maxclass": "newobj",
          "patching_rect": [
            222,
            164,
            43,
            22
          ],
          "varname": "seed_menu",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "bang",
            "bang"
          ],
          "text": "t b b"
        }
      },
      {
        "box": {
          "id": "obj-17",
          "maxclass": "message",
          "patching_rect": [
            215,
            196,
            40,
            22
          ],
          "varname": "clear_menu",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "clear"
        }
      },
      {
        "box": {
          "id": "obj-18",
          "maxclass": "message",
          "patching_rect": [
            262,
            196,
            144,
            22
          ],
          "varname": "none_item",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "append \"No MIDI output\""
        }
      },
      {
        "box": {
          "id": "obj-19",
          "maxclass": "message",
          "patching_rect": [
            470,
            100,
            178,
            22
          ],
          "varname": "default_destination",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "destination \"No MIDI output\""
        }
      },
      {
        "box": {
          "id": "obj-20",
          "maxclass": "newobj",
          "patching_rect": [
            265,
            66,
            124,
            22
          ],
          "varname": "destination",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend destination"
        }
      },
      {
        "box": {
          "id": "obj-21",
          "maxclass": "newobj",
          "patching_rect": [
            535,
            66,
            83,
            22
          ],
          "varname": "play_command",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend play"
        }
      },
      {
        "box": {
          "id": "obj-22",
          "maxclass": "newobj",
          "patching_rect": [
            643,
            66,
            85,
            22
          ],
          "varname": "bpm_command",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend bpm"
        }
      },
      {
        "box": {
          "id": "obj-23",
          "maxclass": "newobj",
          "patching_rect": [
            712,
            66,
            100,
            22
          ],
          "varname": "open_dialog",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "bang"
          ],
          "text": "opendialog .json"
        }
      },
      {
        "box": {
          "id": "obj-24",
          "maxclass": "newobj",
          "patching_rect": [
            823,
            66,
            69,
            22
          ],
          "varname": "save_dialog",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            "bang"
          ],
          "text": "savedialog"
        }
      },
      {
        "box": {
          "id": "obj-25",
          "maxclass": "newobj",
          "patching_rect": [
            711,
            100,
            124,
            22
          ],
          "varname": "open_project",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend openproject"
        }
      },
      {
        "box": {
          "id": "obj-26",
          "maxclass": "newobj",
          "patching_rect": [
            835,
            100,
            124,
            22
          ],
          "varname": "save_project",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend saveproject"
        }
      },
      {
        "box": {
          "id": "obj-27",
          "maxclass": "message",
          "patching_rect": [
            916,
            64,
            124,
            22
          ],
          "varname": "default_filename",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "name \"S4 Project.json\""
        }
      },
      {
        "box": {
          "id": "obj-28",
          "maxclass": "newobj",
          "patching_rect": [
            36,
            65,
            60,
            22
          ],
          "varname": "init",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "bang"
          ],
          "text": "loadbang"
        }
      },
      {
        "box": {
          "id": "obj-29",
          "maxclass": "newobj",
          "patching_rect": [
            36,
            100,
            57,
            22
          ],
          "varname": "defer_init",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "deferlow"
        }
      },
      {
        "box": {
          "id": "obj-30",
          "maxclass": "message",
          "patching_rect": [
            36,
            139,
            30,
            22
          ],
          "varname": "start_clock",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "1"
        }
      },
      {
        "box": {
          "id": "obj-31",
          "maxclass": "newobj",
          "patching_rect": [
            36,
            173,
            60,
            22
          ],
          "varname": "clock",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            "bang"
          ],
          "text": "metro 10"
        }
      },
      {
        "box": {
          "id": "obj-32",
          "maxclass": "newobj",
          "patching_rect": [
            36,
            206,
            60,
            22
          ],
          "varname": "cpuclock",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "float"
          ],
          "text": "cpuclock"
        }
      },
      {
        "box": {
          "id": "obj-33",
          "maxclass": "newobj",
          "patching_rect": [
            36,
            241,
            81,
            22
          ],
          "varname": "tick_command",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend tick"
        }
      },
      {
        "box": {
          "id": "obj-34",
          "maxclass": "newobj",
          "patching_rect": [
            440,
            247,
            148,
            22
          ],
          "varname": "engine",
          "numinlets": 1,
          "numoutlets": 4,
          "outlettype": [
            "",
            "",
            "",
            ""
          ],
          "text": "v8 s4-max.js"
        }
      },
      {
        "box": {
          "id": "obj-35",
          "maxclass": "newobj",
          "patching_rect": [
            487,
            291,
            156,
            22
          ],
          "varname": "native_state",
          "numinlets": 1,
          "numoutlets": 4,
          "outlettype": [
            "",
            "",
            "",
            ""
          ],
          "text": "route bpm playing status"
        }
      },
      {
        "box": {
          "id": "obj-36",
          "maxclass": "newobj",
          "patching_rect": [
            470,
            327,
            79,
            22
          ],
          "varname": "set_bpm",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-37",
          "maxclass": "newobj",
          "patching_rect": [
            558,
            327,
            79,
            22
          ],
          "varname": "set_play",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-38",
          "maxclass": "newobj",
          "patching_rect": [
            647,
            327,
            79,
            22
          ],
          "varname": "set_status",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-39",
          "maxclass": "newobj",
          "patching_rect": [
            333,
            292,
            37,
            22
          ],
          "varname": "raw_midi",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "iter"
        }
      },
      {
        "box": {
          "id": "obj-40",
          "maxclass": "newobj",
          "patching_rect": [
            333,
            329,
            152,
            22
          ],
          "varname": "midi_out",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "text": "midiout none @matchport 1"
        }
      },
      {
        "box": {
          "id": "obj-41",
          "maxclass": "message",
          "patching_rect": [
            970,
            132,
            220,
            22
          ],
          "varname": "load_record_window",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "loadunique \"S4 USB Recorder.maxpat\""
        }
      },
      {
        "box": {
          "id": "obj-42",
          "maxclass": "newobj",
          "patching_rect": [
            970,
            164,
            61,
            22
          ],
          "varname": "record_window",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "pcontrol"
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "obj-28",
            0
          ],
          "destination": [
            "obj-29",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-29",
            0
          ],
          "destination": [
            "obj-13",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-29",
            0
          ],
          "destination": [
            "obj-30",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-29",
            0
          ],
          "destination": [
            "obj-27",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-4",
            0
          ],
          "destination": [
            "obj-13",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-13",
            1
          ],
          "destination": [
            "obj-19",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-13",
            0
          ],
          "destination": [
            "obj-14",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-19",
            0
          ],
          "destination": [
            "obj-34",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-14",
            0
          ],
          "destination": [
            "obj-15",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-15",
            0
          ],
          "destination": [
            "obj-16",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-15",
            1
          ],
          "destination": [
            "obj-3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-16",
            1
          ],
          "destination": [
            "obj-17",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-16",
            0
          ],
          "destination": [
            "obj-18",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-17",
            0
          ],
          "destination": [
            "obj-3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-18",
            0
          ],
          "destination": [
            "obj-3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-3",
            1
          ],
          "destination": [
            "obj-20",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-20",
            0
          ],
          "destination": [
            "obj-34",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-5",
            0
          ],
          "destination": [
            "obj-21",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-21",
            0
          ],
          "destination": [
            "obj-34",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-7",
            0
          ],
          "destination": [
            "obj-22",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-22",
            0
          ],
          "destination": [
            "obj-34",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-8",
            0
          ],
          "destination": [
            "obj-23",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-23",
            0
          ],
          "destination": [
            "obj-25",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-25",
            0
          ],
          "destination": [
            "obj-34",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-9",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-27",
            0
          ],
          "destination": [
            "obj-24",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-24",
            0
          ],
          "destination": [
            "obj-26",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-26",
            0
          ],
          "destination": [
            "obj-34",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-30",
            0
          ],
          "destination": [
            "obj-31",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-31",
            0
          ],
          "destination": [
            "obj-32",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-32",
            0
          ],
          "destination": [
            "obj-33",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-33",
            0
          ],
          "destination": [
            "obj-34",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-12",
            0
          ],
          "destination": [
            "obj-34",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-34",
            0
          ],
          "destination": [
            "obj-39",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-39",
            0
          ],
          "destination": [
            "obj-40",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-34",
            1
          ],
          "destination": [
            "obj-12",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-34",
            2
          ],
          "destination": [
            "obj-35",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-34",
            3
          ],
          "destination": [
            "obj-40",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-35",
            0
          ],
          "destination": [
            "obj-36",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-35",
            1
          ],
          "destination": [
            "obj-37",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-35",
            2
          ],
          "destination": [
            "obj-38",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-36",
            0
          ],
          "destination": [
            "obj-7",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-37",
            0
          ],
          "destination": [
            "obj-5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-38",
            0
          ],
          "destination": [
            "obj-11",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-10",
            0
          ],
          "destination": [
            "obj-41",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-41",
            0
          ],
          "destination": [
            "obj-42",
            0
          ]
        }
      }
    ],
    "autosave": 0
  }
}
