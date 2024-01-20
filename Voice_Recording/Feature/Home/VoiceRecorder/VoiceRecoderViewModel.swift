//
//  VoiceRecoderViewModel.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2024/01/20.
//

import Foundation
import AVFoundation

class VoiceRecoderViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isDisplayRemoveVoiceRecoderAlert: Bool
    @Published var isDisplayAlert: Bool
    @Published var alertMessage: String
    
    // voiceMemo Recoder property
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording: Bool
    
    // voiceMemo Player property
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool
    @Published var isPaused: Bool
    @Published var playedTime: TimeInterval
    private var pregressTimer: Timer?
    
    // VoiveMemo File
    var recordedFile: [URL]
    
    //current VoiceMemoFile
    @Published var selectedRecordedFile: URL?
    
    init(
        isDisplayRemoveVoiceRecoderAlert: Bool = false,
        isDisplayAlert: Bool = false,
        alertMessage: String = "",
        isRecording: Bool = false,
        isPlaying: Bool = false,
        isPaused: Bool = false,
        playedTime: TimeInterval = 0,
        recordedFile: [URL] = [],
        selectedRecordedFile: URL? = nil) {
            self.isDisplayRemoveVoiceRecoderAlert = isDisplayRemoveVoiceRecoderAlert
            self.isDisplayAlert = isDisplayAlert
            self.alertMessage = alertMessage
            self.isRecording = isRecording
            self.isPlaying = isPlaying
            self.isPaused = isPaused
            self.playedTime = playedTime
            self.recordedFile = recordedFile
            self.selectedRecordedFile = selectedRecordedFile
        }
}


// MARK: - voiceMemo for Gesture
extension VoiceRecoderViewModel {
    func tapVoiceRecoderCell(_ recordedFile: URL) {
        if selectedRecordedFile != recordedFile {
            stopPlaying()
            selectedRecordedFile = recordedFile
        }
    }
    
    func tapRemoveBtn() {
        setIsDisplayRemoveVoiceRecorderAlert(true)
    }
    
    func removeSelectedVoiceRecord() {
        guard let fileToRemove = selectedRecordedFile,
              let indexToRemove = recordedFile.firstIndex(of: fileToRemove) else  {
            displayAlert(message: "The selected voice memo file cannot be found.")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: fileToRemove)
            recordedFile.remove(at: indexToRemove)
            selectedRecordedFile = nil
            stopPlaying()
            displayAlert(message: "The selected voice memo file has been deleted.")
            
        } catch {
            displayAlert(message: "An error occurred while deleting the selected voice memo file.")
        }
    }
    
    private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
        isDisplayRemoveVoiceRecoderAlert = isDisplay
    }
    
    private func setErrorAlertMessage(_ message: String) {
        alertMessage = message
    }
    
    private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
        isDisplayAlert = isDisplay
    }
    
    private func displayAlert(message: String) {
        setErrorAlertMessage(message)
        setIsDisplayErrorAlert(true)
    }
}

// MARK: - voiceMemo for Recording
extension VoiceRecoderViewModel {
    func tapRecordBtn(){
        selectedRecordedFile = nil
        if isPlaying {
            stopPlaying()
            startRecording()
        } else if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        let fileURL = getDocumentDirectory().appendingPathComponent("new Rocording\(recordedFile.count + 1)")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            self.isRecording = true
        } catch {
            displayAlert(message: "An error occurred while recording voice memo.")
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        self.recordedFile.append(self.audioRecorder!.url)
        self.isRecording = false
    }
    
    private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


// MARK: - voiceMemo for player
extension VoiceRecoderViewModel {
    func startPlaying(recordingURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            self.isPlaying = true
            self.isPaused = false
            self.pregressTimer = Timer.scheduledTimer(
                withTimeInterval: 0.1,
                repeats: true) { _ in
                    self.updateCurrentTime()
                }
        } catch {
            displayAlert(message: "An error occurred while playing the voice memo.")
        }
    }
    
    private func updateCurrentTime() {
        self.playedTime = audioPlayer?.currentTime ?? 0
    }
    
    private func stopPlaying() {
        audioPlayer?.stop()
        playedTime = 0
        self.pregressTimer?.invalidate()
        self.isPlaying = false
        self.isPaused = false
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        self.isPaused = true
    }
    
    func resumePlaying() {
        audioPlayer?.play()
        self.isPaused = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.isPaused = false
    }
    
    func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
        let fileManager = FileManager.default
        var creationDate: Date?
        var duration: TimeInterval?
        
        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
            creationDate = fileAttributes[.creationDate] as? Date
        } catch {
            displayAlert(message: "The selected voice memo file information could not be loaded.")
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            duration = audioPlayer.duration
        } catch {
            displayAlert(message: "The playback time of the selected voice memo file cannot be loaded.")
        }
        return (creationDate, duration)
    }
}
