package entity

import (
	"encoding/json"
	"fmt"
	"strings"
)

type EventFrame struct {
	ID    string
	Event string
	Data  *EventData
}

type EventData struct {
	Topics  []Topic `json:"topics"`
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

	if len(segments) == 0 {
		return ""
	}

	return strings.Join(segments, "\n") + "\n"
}

var _ fmt.Stringer = new(EventFrame)
