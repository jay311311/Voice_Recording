//
//  VoiceRecoderView.swift
//  Voice_Recording
//
//  Created by Jooeun Kim on 2024/01/20.
//

import SwiftUI

struct VoiceRecoderView: View {
    @StateObject private var voiceRecoderViewModel = VoiceRecoderViewModel()
    
    var body: some View {
        ZStack{
            VStack{
                TitleView()
                if voiceRecoderViewModel.recordedFile.isEmpty {
                    InfoView()
                } else {
                    VoiceRecorderListView(voiceRecoderViewModel: voiceRecoderViewModel)
                        .padding(.top, 15)
                }
                Spacer()
            }
            RecordBtnView(voiceRecoderViewModel: voiceRecoderViewModel)
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert("Will you delete VoiceMemo?",
               isPresented: $voiceRecoderViewModel.isDisplayRemoveVoiceRecoderAlert) {
            Button("delete", role: .destructive) {
                voiceRecoderViewModel.removeSelectedVoiceRecord()
            }
            Button("cancel", role: .cancel) { }
        }
        .alert(voiceRecoderViewModel.alertMessage,
               isPresented: $voiceRecoderViewModel.isDisplayAlert) {
            Button("ok", role: .cancel) {}
        }
    }
}

// MARK: - TitleView
private struct TitleView: View {
    fileprivate var body: some View {
        HStack{
            Text("VoiceMemo")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.customBlack)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

// MARK: - InfoView
private struct InfoView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Rectangle()
                .fill(Color.customCoolGray)
                .frame(height: 1)
            
            Spacer()
                .frame(height: 180)
            
            Image(systemName: "pencil")
                .font(.system(size: 25))
            VStack {
                Text("There are currently no registered voice memos.")
                Text("Click the record button to start the voice memo")
            }
            Spacer()
        }
        .font(.system(size: 15))
        .foregroundColor(.customIconGray)
    }
}

// MARK: - ListView

private struct VoiceRecorderListView: View {
    @ObservedObject private var voiceRecoderViewModel: VoiceRecoderViewModel
    
    fileprivate init(voiceRecoderViewModel: VoiceRecoderViewModel) {
        self.voiceRecoderViewModel = voiceRecoderViewModel
    }
    
    fileprivate var body: some View {
        ScrollView(.vertical) {
            VStack{
                Rectangle()
                    .fill(Color.customGray2)
                    .frame(height: 1)
                
                ForEach(voiceRecoderViewModel.recordedFile, id: \.self) { recordedFile in
                    // 음성메모 셀뷰 호출
                    VoiceRecorderCellView(
                        voiceRecoderViewModel: voiceRecoderViewModel,
                        recordedFile: recordedFile)
                }
            }
        }
    }
}

private struct VoiceRecorderCellView: View {
    @ObservedObject private var voiceRecoderViewModel: VoiceRecoderViewModel
    private var recordedFile: URL
    private var creationDate: Date?
    private var duration: TimeInterval?
    private var progressBarValue: Float {
        if voiceRecoderViewModel.selectedRecordedFile ==  recordedFile
            && (voiceRecoderViewModel.isPlaying || voiceRecoderViewModel.isPaused) {
            return Float(voiceRecoderViewModel.playedTime) / Float(duration ?? 1)
        } else {
            return 0
        }
    }

    fileprivate init(
        voiceRecoderViewModel: VoiceRecoderViewModel,
        recordedFile: URL) {
            self.voiceRecoderViewModel = voiceRecoderViewModel
            self.recordedFile = recordedFile
            (self.creationDate, self.duration) = voiceRecoderViewModel.getFileInfo(for: recordedFile)
    }
    
    fileprivate var body: some View {
        VStack{
            Button {
                voiceRecoderViewModel.tapVoiceRecoderCell(recordedFile)
            } label: {
                VStack{
                    HStack{
                        Text(recordedFile.lastPathComponent)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.customBlack)
                        
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 5)
                    
                    HStack{
                        if let creationDate = creationDate {
                            Text(creationDate.fomattedVoiceRecoderTime)
                                .font(.system(size:14))
                                .foregroundColor(.customIconGray)
                        }
                        
                        Spacer()
                        
                        if voiceRecoderViewModel.selectedRecordedFile != recordedFile,
                           let duration = duration {
                            Text(duration.fomattedTimeInterval)
                                .font(.system(size: 14))
                                .foregroundColor(.customIconGray)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            if voiceRecoderViewModel.selectedRecordedFile == recordedFile {
                VStack {
                    // 프로그래스바
                    ProgressBar(progress: progressBarValue)
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Text(voiceRecoderViewModel.playedTime.fomattedTimeInterval)
                            .font(.system(size: 10))
                            .foregroundColor(.customIconGray)
                        
                        Spacer()
                        
                        if let duration = duration {
                            Text(duration.fomattedTimeInterval)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.customIconGray)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            if voiceRecoderViewModel.isPaused {
                                voiceRecoderViewModel.resumePlaying()
                            } else {
                                voiceRecoderViewModel.startPlaying(recordingURL: recordedFile)
                            }
                        }, label: {
                            Image(systemName: "play.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.customBlack)
                        })
                        
                        Spacer()
                            .frame(width: 10)
                        
                        Button(action: {
                            if voiceRecoderViewModel.isPlaying{
                                voiceRecoderViewModel.pausePlaying()
                            }
                        }, label: {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.customBlack)
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            voiceRecoderViewModel.tapRemoveBtn()
                        }, label: {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.customBlack)
                        })
                    }
                }
                .padding(.horizontal, 20)
            }
            Rectangle()
                .fill(Color.customGray2)
                .frame(height: 1)
        }
    }
}

// MARK: -  progresbar

private struct ProgressBar: View {
    private var progress: Float
    
    fileprivate init(progress: Float) {
        self.progress = progress
    }
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.customGray2)
                
                Rectangle()
                    .fill(Color.customGreen2)
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
            }
            
        }
    }
    
}

private struct RecordBtnView: View {
    @ObservedObject private var voiceRecoderViewModel: VoiceRecoderViewModel
    
    fileprivate init(voiceRecoderViewModel: VoiceRecoderViewModel) {
        self.voiceRecoderViewModel = voiceRecoderViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack{
                Spacer()
                
                Button(action: {
                    voiceRecoderViewModel.tapRecordBtn()
                }, label: {
                    if voiceRecoderViewModel.isRecording {
                        Image(systemName: "record.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "record.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.customGray0)
                    }
                })
            }
        }
    }
    
}




struct VoiceRecoderView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceRecoderView()
    }
}
