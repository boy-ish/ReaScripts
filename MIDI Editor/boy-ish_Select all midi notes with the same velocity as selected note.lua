-- ReaScript Name: mrkbrg_Select all midi notes with the same velocity as selected note
-- About: This script will select all MIDI notes with the same velocity in the same take as long as only one MIDI note is selected.
-- Author: Mark Berg
-- Website: https://markbergsound.com
-- Repository:
-- Forum Thread:
-- REAPER: 6.79
-- Version: 1.0
-- Changelog
--  v1.0 (2023-09-15)
--    # Initial Release


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~ GLOBAL VARS ~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local take
local sel_note_velocity

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Msg(val)
  reaper.ShowMessageBox(tostring(val) .. "\n", "Info", 0)
end


function GetSelectedNoteVelocity()
  local selected_note_count = 0
  local _, notes = reaper.MIDI_CountEvts(take)
  
  for i = 0, notes - 1 do
    local _, selected = reaper.MIDI_GetNote(take, i)
    if selected then
      selected_note_count = selected_note_count + 1
      _,_,_,_,_,_,_,note_velocity = reaper.MIDI_GetNote(take, i)
    end
  end
    if selected_note_count == 1 then
      sel_note_velocity = note_velocity
      return sel_note_velocity
    elseif selected_note_count < 1 then
      return Msg("You need to select a MIDI note")
    else
      return Msg("Please Select Only One Midi Note")
    end
end

function SelectMIDINotesWithSameVelocity()
  local notevelocity = sel_note_velocity
  local _, notes = reaper.MIDI_CountEvts(take)
  
  for i = 0, notes -1 do
    local _,_,_,_,_,_,_,velocity = reaper.MIDI_GetNote(take,i)
    if velocity == notevelocity then
     reaper.MIDI_SetNote(take,i,true)
    end
  end
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~ MAIN ~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


function Main()
  local midi_editor = reaper.MIDIEditor_GetActive()
  take = reaper.MIDIEditor_GetTake(midi_editor)
  
  if not take then
    return Msg("No active MIDI editor")
  else
    GetSelectedNoteVelocity()
    SelectMIDINotesWithSameVelocity()
  end
end

reaper.PreventUIRefresh(1)

Main()

reaper.PreventUIRefresh(-1)

reaper.UpdateArrange() -- Update the arrangement (often needed)
