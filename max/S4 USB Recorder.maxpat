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
      92,
      104,
      689,
      518
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
    "default_fontname": "Arial",
    "default_fontsize": 12,
    "boxes": [
      {
        "box": {
          "id": "obj-1",
          "maxclass": "comment",
          "patching_rect": [
            24,
            17,
            600,
            31
          ],
          "varname": "title",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            24,
            17,
            600,
            31
          ],
          "text": "TORSO  /  S-4 USB RECORDER",
          "fontsize": 22,
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-2",
          "maxclass": "comment",
          "patching_rect": [
            24,
            52,
            655,
            23
          ],
          "varname": "subtitle",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            24,
            52,
            655,
            23
          ],
          "text": "Four tracks and the main mix, captured as five stereo 24-bit WAV files.",
          "fontsize": 13,
          "textcolor": [
            0.66,
            0.73,
            0.77,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-3",
          "maxclass": "comment",
          "patching_rect": [
            24,
            86,
            660,
            22
          ],
          "varname": "audio_setup",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            24,
            86,
            660,
            22
          ],
          "text": "Max Audio Status: select S4 as Input Device, enable all ten inputs, then turn Audio on.",
          "fontsize": 12,
          "textcolor": [
            0.66,
            0.73,
            0.77,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-4",
          "maxclass": "textbutton",
          "patching_rect": [
            24,
            128,
            132,
            31
          ],
          "varname": "choose_folder",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            24,
            128,
            132,
            31
          ],
          "text": "Choose Folder…",
          "mode": 0,
          "outputmode": 1,
          "bgcolor": [
            0.18,
            0.23,
            0.26,
            1.0
          ],
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1.0
          ],
          "rounded": 5.0
        }
      },
      {
        "box": {
          "id": "obj-5",
          "maxclass": "comment",
          "patching_rect": [
            167,
            132,
            502,
            28
          ],
          "varname": "destination",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            167,
            132,
            502,
            28
          ],
          "text": "No destination selected",
          "fontsize": 12,
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-6",
          "maxclass": "comment",
          "patching_rect": [
            24,
            184,
            104,
            22
          ],
          "varname": "prefix_label",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            24,
            184,
            104,
            22
          ],
          "text": "Take prefix",
          "fontsize": 12,
          "textcolor": [
            0.66,
            0.73,
            0.77,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-7",
          "maxclass": "textedit",
          "patching_rect": [
            113,
            180,
            233,
            29
          ],
          "varname": "take_prefix",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "int",
            ""
          ],
          "presentation": 1,
          "presentation_rect": [
            113,
            180,
            233,
            29
          ],
          "text": "S4",
          "lines": 1,
          "keymode": 1,
          "bangmode": 0,
          "wordwrap": 0,
          "bgcolor": [
            0.18,
            0.23,
            0.26,
            1.0
          ],
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-8",
          "maxclass": "textbutton",
          "patching_rect": [
            397,
            176,
            124,
            37
          ],
          "varname": "record_button",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            397,
            176,
            124,
            37
          ],
          "text": "Record",
          "mode": 0,
          "outputmode": 1,
          "bgcolor": [
            0.56,
            0.16,
            0.2,
            1.0
          ],
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1.0
          ],
          "rounded": 5.0
        }
      },
      {
        "box": {
          "id": "obj-9",
          "maxclass": "textbutton",
          "patching_rect": [
            537,
            176,
            124,
            37
          ],
          "varname": "stop_button",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            "int"
          ],
          "presentation": 1,
          "presentation_rect": [
            537,
            176,
            124,
            37
          ],
          "text": "Stop",
          "mode": 0,
          "outputmode": 1,
          "bgcolor": [
            0.18,
            0.23,
            0.26,
            1.0
          ],
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1.0
          ],
          "rounded": 5.0
        }
      },
      {
        "box": {
          "id": "obj-10",
          "maxclass": "comment",
          "patching_rect": [
            24,
            229,
            642,
            43
          ],
          "varname": "recorder_status",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            24,
            229,
            642,
            43
          ],
          "text": "Choose a destination folder.",
          "fontsize": 14,
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-11",
          "maxclass": "comment",
          "patching_rect": [
            24,
            287,
            100,
            20
          ],
          "varname": "input_pairs",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            24,
            287,
            100,
            20
          ],
          "text": "INPUT PAIRS",
          "fontsize": 11,
          "textcolor": [
            0.66,
            0.73,
            0.77,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-12",
          "maxclass": "comment",
          "patching_rect": [
            152,
            287,
            20,
            20
          ],
          "varname": "channel_left",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            152,
            287,
            20,
            20
          ],
          "text": "L",
          "fontsize": 11,
          "textcolor": [
            0.66,
            0.73,
            0.77,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-13",
          "maxclass": "comment",
          "patching_rect": [
            408,
            287,
            20,
            20
          ],
          "varname": "channel_right",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            408,
            287,
            20,
            20
          ],
          "text": "R",
          "fontsize": 11,
          "textcolor": [
            0.66,
            0.73,
            0.77,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-14",
          "maxclass": "comment",
          "patching_rect": [
            24,
            309,
            127,
            20
          ],
          "varname": "pair_label_0",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            24,
            309,
            127,
            20
          ],
          "text": "Main   1/2",
          "fontsize": 12,
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-15",
          "maxclass": "meter~",
          "patching_rect": [
            155,
            312,
            235,
            13
          ],
          "varname": "meter_1",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            155,
            312,
            235,
            13
          ],
          "interval": 120
        }
      },
      {
        "box": {
          "id": "obj-16",
          "maxclass": "meter~",
          "patching_rect": [
            411,
            312,
            235,
            13
          ],
          "varname": "meter_2",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            411,
            312,
            235,
            13
          ],
          "interval": 120
        }
      },
      {
        "box": {
          "id": "obj-17",
          "maxclass": "comment",
          "patching_rect": [
            24,
            338,
            127,
            20
          ],
          "varname": "pair_label_1",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            24,
            338,
            127,
            20
          ],
          "text": "Track 1   3/4",
          "fontsize": 12,
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-18",
          "maxclass": "meter~",
          "patching_rect": [
            155,
            341,
            235,
            13
          ],
          "varname": "meter_3",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            155,
            341,
            235,
            13
          ],
          "interval": 120
        }
      },
      {
        "box": {
          "id": "obj-19",
          "maxclass": "meter~",
          "patching_rect": [
            411,
            341,
            235,
            13
          ],
          "varname": "meter_4",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            411,
            341,
            235,
            13
          ],
          "interval": 120
        }
      },
      {
        "box": {
          "id": "obj-20",
          "maxclass": "comment",
          "patching_rect": [
            24,
            367,
            127,
            20
          ],
          "varname": "pair_label_2",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            24,
            367,
            127,
            20
          ],
          "text": "Track 2   5/6",
          "fontsize": 12,
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-21",
          "maxclass": "meter~",
          "patching_rect": [
            155,
            370,
            235,
            13
          ],
          "varname": "meter_5",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            155,
            370,
            235,
            13
          ],
          "interval": 120
        }
      },
      {
        "box": {
          "id": "obj-22",
          "maxclass": "meter~",
          "patching_rect": [
            411,
            370,
            235,
            13
          ],
          "varname": "meter_6",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            411,
            370,
            235,
            13
          ],
          "interval": 120
        }
      },
      {
        "box": {
          "id": "obj-23",
          "maxclass": "comment",
          "patching_rect": [
            24,
            396,
            127,
            20
          ],
          "varname": "pair_label_3",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            24,
            396,
            127,
            20
          ],
          "text": "Track 3   7/8",
          "fontsize": 12,
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-24",
          "maxclass": "meter~",
          "patching_rect": [
            155,
            399,
            235,
            13
          ],
          "varname": "meter_7",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            155,
            399,
            235,
            13
          ],
          "interval": 120
        }
      },
      {
        "box": {
          "id": "obj-25",
          "maxclass": "meter~",
          "patching_rect": [
            411,
            399,
            235,
            13
          ],
          "varname": "meter_8",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            411,
            399,
            235,
            13
          ],
          "interval": 120
        }
      },
      {
        "box": {
          "id": "obj-26",
          "maxclass": "comment",
          "patching_rect": [
            24,
            425,
            127,
            20
          ],
          "varname": "pair_label_4",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            24,
            425,
            127,
            20
          ],
          "text": "Track 4   9/10",
          "fontsize": 12,
          "textcolor": [
            0.93,
            0.95,
            0.96,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-27",
          "maxclass": "meter~",
          "patching_rect": [
            155,
            428,
            235,
            13
          ],
          "varname": "meter_9",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            155,
            428,
            235,
            13
          ],
          "interval": 120
        }
      },
      {
        "box": {
          "id": "obj-28",
          "maxclass": "meter~",
          "patching_rect": [
            411,
            428,
            235,
            13
          ],
          "varname": "meter_10",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "float"
          ],
          "presentation": 1,
          "presentation_rect": [
            411,
            428,
            235,
            13
          ],
          "interval": 120
        }
      },
      {
        "box": {
          "id": "obj-29",
          "maxclass": "comment",
          "patching_rect": [
            24,
            471,
            640,
            22
          ],
          "varname": "monitor_note",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "presentation": 1,
          "presentation_rect": [
            24,
            471,
            640,
            22
          ],
          "text": "Meters show USB input. Listen through the S-4 or your existing monitor path.",
          "fontsize": 12,
          "textcolor": [
            0.66,
            0.73,
            0.77,
            1.0
          ]
        }
      },
      {
        "box": {
          "id": "obj-30",
          "maxclass": "newobj",
          "patching_rect": [
            24,
            520,
            105,
            22
          ],
          "varname": "dialog",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "bang"
          ],
          "text": "opendialog fold"
        }
      },
      {
        "box": {
          "id": "obj-31",
          "maxclass": "newobj",
          "patching_rect": [
            24,
            553,
            154,
            22
          ],
          "varname": "absolute_folder",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "int"
          ],
          "text": "conformpath slash boot"
        }
      },
      {
        "box": {
          "id": "obj-32",
          "maxclass": "newobj",
          "patching_rect": [
            24,
            581,
            98,
            22
          ],
          "varname": "folder_message",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend folder"
        }
      },
      {
        "box": {
          "id": "obj-33",
          "maxclass": "newobj",
          "patching_rect": [
            158,
            520,
            70,
            22
          ],
          "varname": "prefix_route",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "text": "route text"
        }
      },
      {
        "box": {
          "id": "obj-34",
          "maxclass": "newobj",
          "patching_rect": [
            158,
            553,
            98,
            22
          ],
          "varname": "prefix_message",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend prefix"
        }
      },
      {
        "box": {
          "id": "obj-35",
          "maxclass": "newobj",
          "patching_rect": [
            290,
            520,
            63,
            22
          ],
          "varname": "record_order",
          "numinlets": 1,
          "numoutlets": 4,
          "outlettype": [
            "bang",
            "bang",
            "bang",
            "bang"
          ],
          "text": "t b b b b"
        }
      },
      {
        "box": {
          "id": "obj-36",
          "maxclass": "message",
          "patching_rect": [
            290,
            553,
            48,
            22
          ],
          "varname": "start",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "start"
        }
      },
      {
        "box": {
          "id": "obj-37",
          "maxclass": "message",
          "patching_rect": [
            363,
            553,
            48,
            22
          ],
          "varname": "stop",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "stop"
        }
      },
      {
        "box": {
          "id": "obj-38",
          "maxclass": "newobj",
          "patching_rect": [
            423,
            520,
            63,
            22
          ],
          "varname": "dspstate",
          "numinlets": 1,
          "numoutlets": 4,
          "outlettype": [
            "int",
            "float",
            "int",
            "int"
          ],
          "text": "dspstate~"
        }
      },
      {
        "box": {
          "id": "obj-39",
          "maxclass": "newobj",
          "patching_rect": [
            423,
            553,
            77,
            22
          ],
          "varname": "dsp_message",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend dsp"
        }
      },
      {
        "box": {
          "id": "obj-40",
          "maxclass": "newobj",
          "patching_rect": [
            523,
            520,
            126,
            22
          ],
          "varname": "numinputs",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            "int"
          ],
          "text": "adstatus numinputs"
        }
      },
      {
        "box": {
          "id": "obj-41",
          "maxclass": "newobj",
          "patching_rect": [
            523,
            553,
            98,
            22
          ],
          "varname": "inputs_message",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "prepend inputs"
        }
      },
      {
        "box": {
          "id": "obj-42",
          "maxclass": "newobj",
          "patching_rect": [
            24,
            625,
            56,
            22
          ],
          "varname": "load",
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
          "id": "obj-43",
          "maxclass": "message",
          "patching_rect": [
            99,
            625,
            48,
            22
          ],
          "varname": "init",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "text": "init"
        }
      },
      {
        "box": {
          "id": "obj-44",
          "maxclass": "newobj",
          "patching_rect": [
            164,
            625,
            63,
            22
          ],
          "varname": "close",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            "bang"
          ],
          "text": "closebang"
        }
      },
      {
        "box": {
          "id": "obj-45",
          "maxclass": "newobj",
          "patching_rect": [
            290,
            625,
            119,
            22
          ],
          "varname": "controller",
          "numinlets": 1,
          "numoutlets": 4,
          "outlettype": [
            "",
            "",
            "",
            ""
          ],
          "text": "v8 s4-recorder.js"
        }
      },
      {
        "box": {
          "id": "obj-46",
          "maxclass": "newobj",
          "patching_rect": [
            25,
            666,
            175,
            22
          ],
          "varname": "adc",
          "numinlets": 1,
          "numoutlets": 10,
          "outlettype": [
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal",
            "signal"
          ],
          "text": "adc~ 1 2 3 4 5 6 7 8 9 10"
        }
      },
      {
        "box": {
          "id": "obj-47",
          "maxclass": "newobj",
          "patching_rect": [
            291,
            666,
            343,
            22
          ],
          "varname": "splitter",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "text": "node.script s4-split-wav.js @autostart 1 @defer 1"
        }
      },
      {
        "box": {
          "id": "obj-48",
          "maxclass": "newobj",
          "patching_rect": [
            24,
            720,
            84,
            22
          ],
          "varname": "writer",
          "numinlets": 10,
          "numoutlets": 1,
          "outlettype": [
            "signal"
          ],
          "text": "sfrecord~ 10"
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "obj-46",
            0
          ],
          "destination": [
            "obj-48",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-46",
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
            "obj-46",
            1
          ],
          "destination": [
            "obj-48",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-46",
            1
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
            "obj-46",
            2
          ],
          "destination": [
            "obj-48",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-46",
            2
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
            "obj-46",
            3
          ],
          "destination": [
            "obj-48",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-46",
            3
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
            "obj-46",
            4
          ],
          "destination": [
            "obj-48",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-46",
            4
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
            "obj-46",
            5
          ],
          "destination": [
            "obj-48",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-46",
            5
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
            "obj-46",
            6
          ],
          "destination": [
            "obj-48",
            6
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-46",
            6
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
            "obj-46",
            7
          ],
          "destination": [
            "obj-48",
            7
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-46",
            7
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
            "obj-46",
            8
          ],
          "destination": [
            "obj-48",
            8
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-46",
            8
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
            "obj-46",
            9
          ],
          "destination": [
            "obj-48",
            9
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-46",
            9
          ],
          "destination": [
            "obj-28",
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
            "obj-30",
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
            "obj-45",
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
            "obj-34",
            0
          ],
          "destination": [
            "obj-45",
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
            "obj-35",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-35",
            3
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
            "obj-35",
            2
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
            1
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
            "obj-36",
            0
          ],
          "destination": [
            "obj-45",
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
            "obj-37",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-44",
            0
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
            "obj-37",
            0
          ],
          "destination": [
            "obj-45",
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
            "obj-45",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-40",
            1
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
            "obj-45",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-42",
            0
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
            "obj-42",
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
            "obj-42",
            0
          ],
          "destination": [
            "obj-43",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-43",
            0
          ],
          "destination": [
            "obj-45",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-45",
            0
          ],
          "destination": [
            "obj-48",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-45",
            1
          ],
          "destination": [
            "obj-47",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-47",
            0
          ],
          "destination": [
            "obj-45",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-45",
            2
          ],
          "destination": [
            "obj-10",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-45",
            3
          ],
          "destination": [
            "obj-5",
            0
          ]
        }
      }
    ],
    "dependency_cache": [
      {
        "name": "s4-recorder.js",
        "patcherrelativepath": ".",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "s4-split-wav.js",
        "patcherrelativepath": ".",
        "type": "TEXT",
        "implicit": 1
      }
    ],
    "autosave": 0
  }
}
