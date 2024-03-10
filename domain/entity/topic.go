package entity

type Topic = string

var TopicChannelIDs = map[Topic][]string{
	"faloop_announcement": {"581962767767175168"},
	"faloop_lodestone":    {"614267549139337217"},
	"faloop_maintenance":  {"614267746691186692"},

	// Elemental DC
	"faloop_elemental_s_manual": {"888668567065731082"},
	"faloop_elemental_a_tour":   {"588506294990798877"},
	"faloop_elemental_forum":    {"711480769217822760"},

	// Mana DC
	"faloop_mana_s_manual": {"985337571712331776"},
	"faloop_mana_a_tour":   {"668277147005222922"},
	"faloop_mana_forum":    {"669119456710098944"},

	// Gaia DC
	"faloop_gaia_s_manual": {"989046018253422622"},
	"faloop_gaia_a_tour":   {"888186087963496448"},
	"faloop_gaia_forum":    {"888186398358773760"},

	// Meteor DC
	"faloop_meteor_s_manual": {"986138192631693322"},
	"faloop_meteor_a_tour":   {"986138725866164234"},
	"faloop_meteor_forum":    {"986142981901942784"},
}
