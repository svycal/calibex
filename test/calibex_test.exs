defmodule CalibexTest do
  use ExUnit.Case

  test "ical encoding" do
    res =
      Calibex.encode(
        vcalendar: [
          [
            prodid: "-//Google Inc//Google Calendar 70.9054//EN",
            version: "2.0",
            calscale: "GREGORIAN",
            method: "REQUEST",
            vevent: [
              [
                dtstart: Timex.to_datetime({{2017, 5, 14}, {9, 0, 0}}, "Europe/Paris"),
                dtend: Timex.to_datetime({{2017, 5, 14}, {10, 0, 0}}, "Europe/Paris"),
                dtstamp: Timex.to_datetime({{2017, 5, 13}, {10, 52, 50}}, "UTC"),
                organizer: [cn: "Arnaud Wetzel", value: "mailto:arnaud.wetzel@example.com"],
                uid: "r30al68kn0b2epd9af6kqjg8rg@google.com",
                attendee: [
                  cutype: "INDIVIDUAL",
                  role: "REQ-PARTICIPANT",
                  partstat: "NEEDS-ACTION",
                  rsvp: true,
                  cn: "arnaudwetzel@examp.com",
                  "x-num-guests": 0,
                  value: "mailto:arnaudwetzel@examp.com"
                ],
                attendee: [
                  cutype: "INDIVIDUAL",
                  role: "REQ-PARTICIPANT",
                  partstat: "ACCEPTED",
                  rsvp: true,
                  cn: "Arnaud Wetzel",
                  x_num_guests: 0,
                  value: "mailto:arnaud.wetzel@example.com"
                ],
                created: Timex.to_datetime({{2017, 5, 13}, {10, 50, 32}}, "UTC"),
                description:
                  String.trim_trailing("""
                  Cet événement est associé à un appel vidéo Google Hangouts.
                  Participer : https://plus.google.com/hangouts/_/exampleexampl.com/arnaud-wetzel?hceid=YXJuYXVkLndldHplbEBrYnJ3YWR2ZW50dXJlLmNvbQ.r30al68kn0b2epd9af6kqjg8rg&hs=121

                  Affichez votre événement sur la page https://www.google.com/calendar/event?action=VIEW&eid=cjMwYWw2OGtuMGIyZXBkOWFmNmtxamc4cmcgYXJuYXVkd2V0emVsQHlhaG9vLmNvbQ&tok=MzEjYXJuYXVkLndldHplbEBrYnJ3YWR2ZW50dXJlLmNvbTdjMzQ0ZGFjN2FlYTM2OGI2NzEzNjAzZjVmNzk2NDVkMjA5ZDc0YjQ&ctz=Europe/Paris&hl=fr.
                  """),
                last_modified: Timex.to_datetime({{2017, 5, 13}, {10, 52, 49}}, "UTC"),
                location: "",
                sequence: 0,
                status: "CONFIRMED",
                summary: "c'est un évènement de test",
                transp: "OPAQUE"
              ]
            ]
          ]
        ]
      )

    assert res == File.read!("test/fixtures/invite.ics")
  end

  test "bijective codec" do
    ical = File.read!("test/fixtures/invite2.ics")
    assert ical |> Calibex.decode() |> Calibex.encode() == ical
  end

  # test "ical decoding" do
  #  res =Calibex.decode(File.read!("test/fixtures/invite2.ics"))
  #  IO.inspect(res, pretty: true, limit: :infinity)
  # end

  test "ical helpers" do
    req =
      Calibex.request(
        dtstart: Timex.now(),
        dtend: Timex.shift(Timex.now(), hours: 1),
        summary: "Mon évènement",
        organizer: "arnaud.wetzel@example.com",
        attendee: "jeanpierre@yahoo.fr",
        attendee: "jean@ya.fr"
      )

    assert [
             vcalendar: [
               [
                 prodid: "-//KBRW//Calibex 0.1.0//EN",
                 version: "2.0",
                 calscale: "GREGORIAN",
                 method: "REQUEST",
                 vevent: [
                   [
                     uid: _,
                     last_modified: %DateTime{},
                     sequence: 0,
                     dtstamp: %DateTime{},
                     created: %DateTime{},
                     status: :confirmed,
                     dtstart: %DateTime{},
                     dtend: %DateTime{},
                     summary: "Mon évènement",
                     organizer: [
                       cn: "arnaud.wetzel@example.com",
                       value: "mailto:arnaud.wetzel@example.com"
                     ],
                     attendee: [
                       cutype: "INDIVIDUAL",
                       role: "REQ-PARTICIPANT",
                       partstat: "NEEDS-ACTION",
                       rsvp: true,
                       x_num_guests: 0,
                       cn: "jeanpierre@yahoo.fr",
                       value: "mailto:jeanpierre@yahoo.fr"
                     ],
                     attendee: [
                       cutype: "INDIVIDUAL",
                       role: "REQ-PARTICIPANT",
                       partstat: "NEEDS-ACTION",
                       rsvp: true,
                       x_num_guests: 0,
                       cn: "jean@ya.fr",
                       value: "mailto:jean@ya.fr"
                     ]
                   ]
                 ]
               ]
             ]
           ] = req
  end

  test "handles Apple structured location data" do
    ical = File.read!("test/fixtures/invite-with-apple-location.ics")

    assert [
             vcalendar: [
               [
                 prodid: "-//Google Inc//Google Calendar 70.9054//EN",
                 version: "2.0",
                 calscale: "GREGORIAN",
                 method: "REQUEST",
                 vevent: [
                   [
                     dtstart: "20170514T070000Z",
                     dtend: "20170514T080000Z",
                     dtstamp: "20170513T105250Z",
                     organizer: [value: "mailto:arnaud.wetzel@example.com", cn: "Arnaud Wetzel"],
                     uid: "r30al68kn0b2epd9af6kqjg8rg@google.com",
                     attendee: [
                       value: "mailto:arnaudwetzel@examp.com",
                       cutype: "INDIVIDUAL",
                       role: "REQ-PARTICIPANT",
                       partstat: "NEEDS-ACTION",
                       rsvp: "TRUE",
                       cn: "arnaudwetzel@examp.com",
                       x_num_guests: "0"
                     ],
                     attendee: [
                       value: "mailto:arnaud.wetzel@example.com",
                       cutype: "INDIVIDUAL",
                       role: "REQ-PARTICIPANT",
                       partstat: "ACCEPTED",
                       rsvp: "TRUE",
                       cn: "Arnaud Wetzel",
                       x_num_guests: "0"
                     ],
                     created: "20170513T105032Z",
                     description:
                       "Cet événement est associé à un appel vidéo Google Hangouts.\nParticiper : https://plus.google.com/hangouts/_/exampleexampl.com/arnaud-wetzel?hceid=YXJuYXVkLndldHplbEBrYnJ3YWR2ZW50dXJlLmNvbQ.r30al68kn0b2epd9af6kqjg8rg&hs=121\n\nAffichez votre événement sur la page https://www.google.com/calendar/event?action=VIEW&eid=cjMwYWw2OGtuMGIyZXBkOWFmNmtxamc4cmcgYXJuYXVkd2V0emVsQHlhaG9vLmNvbQ&tok=MzEjYXJuYXVkLndldHplbEBrYnJ3YWR2ZW50dXJlLmNvbTdjMzQ0ZGFjN2FlYTM2OGI2NzEzNjAzZjVmNzk2NDVkMjA5ZDc0YjQ&ctz=Europe/Paris&hl=fr.",
                     x_apple_structured_location: [
                       value: "geo:42.145927,-100.585260 ",
                       value: "URI",
                       x_address: "\"500 Nicollet St, Minneapoli s, MN, United Stat\"",
                       x_apple_mapkit_handle:
                         "CAEStwIIrk0QnsWIkObE3qLyARoS CVSPNLitEkpAEUGK8OV0pVrAIpoBCgZDYW5hZGESAkNBGgxTYXNrYXRjaGV3YW4iAlNLKg9EaXZpc2lvbiBOby4gMTEyCVNhc2thdG9vbjoHUzdOIDNQOUIMRm9yZXN0IEdyb3ZlUgpXZWJzdGVyIFN0WgM1MDJiDjUwMiBXZWJzdGVyIFN0igEWVW5pdmVyc2l0eSBIZWlnaHRzIFNEQYoBDEZvcmVzdCBHcm92ZSodRm9yZXN0IEdyb3ZlIENvbW11bml0eSBDaHVyY2gyDjUwMiBXZWJzdGVyIFN0MhRTYXNrYXRvb24gU0sgUzdOIDNQOTIGQ2FuYWRhOC9aJwolCJ7FiJDmxN6i8gESEglUjzS4rRJKQBFBivDldKVawBiuTZADAQ==",
                       x_apple_radius: "123.4774275404302",
                       x_apple_referenceframe: "1",
                       x_title: "The Wedge"
                     ],
                     last_modified: "20170513T105249Z",
                     location: "",
                     sequence: "0",
                     status: "CONFIRMED",
                     summary: "c'est un évènement de test",
                     transp: "OPAQUE"
                   ]
                 ]
               ]
             ]
           ] = ical |> Calibex.decode()
  end
end
