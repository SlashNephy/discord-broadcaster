package entity

import (
	"encoding/json"
	"fmt"
	"strings"
)

type EventFrame struct {
	ID      string     `json:"id,omitempty"`
	Event   string     `json:"event,omitempty"`
	Data    *EventData `json:"data,omitempty"`
	Comment string     `json:"comment,omitempty"`
}

type EventData struct {
	Topics  []Topic `json:"topics,omitempty"`
	Payload any     `json:"payload"`
}

func (f *EventFrame) String() string {
	var segments []string
	if f.ID != "" {
		segments = append(segments, fmt.Sprintf("id: %s", f.ID))
	}
	if f.Event != "" {
		segments = append(segments, fmt.Sprintf("event: %s", f.Event))
	}
	if f.Data != nil {
		data, err := json.Marshal(f.Data)
		if err != nil {
			return ""
		}
		segments = append(segments, fmt.Sprintf("data: %s", data))
	}
	if f.Comment != "" {
		segments = append(segments, fmt.Sprintf(": %s", f.Comment))
	}

	if len(segments) == 0 {
		return ""
	}

	return strings.Join(segments, "\n") + "\n\n"
}

var _ fmt.Stringer = new(EventFrame)
