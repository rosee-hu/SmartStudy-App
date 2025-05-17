import SwiftUI

struct PomodoroView: View {
    @State private var timeRemaining = 1500  // Start with 25 minutes (1500 seconds)
    @State private var timerRunning = false
    @State private var showAlert = false
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let pomodoroColor = Color(hex: "#66b8a0")  // Define the color for the circle and buttons

    var body: some View {
        VStack(spacing: 20) {
            // Title at the top
            Text("Pomodoro")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(pomodoroColor)
                .padding(.top)

            // Circle Progress with Time Remaining
            ZStack {
                // Background Circle (Track)
                Circle()
                    .stroke(lineWidth: 20)
                    .foregroundColor(Color.gray.opacity(0.3))

                // Foreground Circle (Progress)
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / 1500)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(pomodoroColor)
                    .rotationEffect(.degrees(-90))

                // Time Remaining Number in Center
                Text(formatTime(timeRemaining))
                    .font(.system(size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(pomodoroColor) // Timer color changed to #66b8a0
            }
            .frame(width: 200, height: 200)
            .padding()

            // Timer Controls
            HStack {
                Button("Start") {
                    if timeRemaining > 0 {
                        timerRunning = true
                    }
                }
                .padding()
                .background(Color.white)
                .foregroundColor(pomodoroColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(pomodoroColor, lineWidth: 2)  // Adding border around the button
                )

                Button("Pause") {
                    timerRunning = false
                }
                .padding()
                .background(Color.white)
                .foregroundColor(pomodoroColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(pomodoroColor, lineWidth: 2)  // Adding border around the button
                )

                Button("Reset") {
                    timerRunning = false
                    timeRemaining = 1500  // Reset back to 25 minutes
                }
                .padding()
                .background(Color.white)
                .foregroundColor(pomodoroColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(pomodoroColor, lineWidth: 2)  // Adding border around the button
                )
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Pomodoro timer is running!"), message: Text("Can't exit before timer finished."), dismissButton: .default(Text("OK")))
        }
        .onReceive(timer) { _ in
            if timerRunning && timeRemaining > 0 {
                timeRemaining -= 1  // Decrease time by 1 second
            } else if timeRemaining == 0 {
                timerRunning = false
                showAlert = true  // Show an alert when timer finishes
            }
        }

        // Bottom Navigation Bar (Fixed at the Bottom)
        HStack {
            NavigationLink(destination: DashboardView()) {
                VStack {
                    Image(systemName: "house.fill")  // Home icon
                        .font(.title2)
                    Text("Home")
                        .font(.footnote)
                }
                .foregroundColor(.black)  // Set icon and text to black
                .padding()  // Padding for space between icon and text
            }

            NavigationLink(destination: PomodoroView()) {
                VStack {
                    Image(systemName: "clock.fill")  // Pomodoro icon
                        .font(.title2)
                    Text("Pomodoro")
                        .font(.footnote)
                }
                .foregroundColor(.black)  // Set icon and text to black
                .padding()  // Padding for space between icon and text
            }

            NavigationLink(destination: ClassesView()) {
                VStack {
                    Image(systemName: "book.fill")  // Classes icon
                        .font(.title2)
                    Text("Classes")
                        .font(.footnote)
                }
                .foregroundColor(.black)  // Set icon and text to black
                .padding()  // Padding for space between icon and text
            }

            NavigationLink(destination: ProgressView()) {
                VStack {
                    Image(systemName: "chart.bar.fill")  // Progress icon
                        .font(.title2)
                    Text("Progress")
                        .font(.footnote)
                }
                .foregroundColor(.black)  // Set icon and text to black
                .padding()  // Padding for space between icon and text
            }
        }
        .padding(.bottom, 10)  // Padding at the bottom
        .background(Color.white)  // Background to white for navigation bar
        .shadow(radius: 5)  // Shadow for better visibility
        .frame(maxWidth: .infinity)  // Full width for the navigation bar
    }

    func formatTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        if hexSanitized.count == 6 {
            let scanner = Scanner(string: hexSanitized)
            var rgb: UInt64 = 0
            if scanner.scanHexInt64(&rgb) {
                let r = Double((rgb & 0xFF0000) >> 16) / 255.0
                let g = Double((rgb & 0x00FF00) >> 8) / 255.0
                let b = Double(rgb & 0x0000FF) / 255.0
                self.init(red: r, green: g, blue: b)
                return
            }
        }
        self.init(red: 0, green: 0, blue: 0)
    }
}
