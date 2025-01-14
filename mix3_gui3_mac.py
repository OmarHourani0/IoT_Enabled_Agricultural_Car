import serial
import time
import requests
from threading import Thread
import tkinter as tk


# Update this based on your connected device
serial_port = "/dev/tty.HC-06"
baud_rate = 9600


thingspeak_url = "https://api.thingspeak.com/update"
thingspeak_api_key = "7GQI7ZZNATJ9UJUI"

running = True


def process_data(data):
    """Processes a line of data and sends it to ThingSpeak."""
    try:
        print(f"Received data: {data.strip()}")
        values = [v.strip() for v in data.split(",")]
        if len(values) < 5:
            print("Malformed data received. Skipping...")
            return

        # Parsing and sending data
        distance, ldr, moisture, temperature, ph = map(float, values[:5])
        payload = {
            "api_key": thingspeak_api_key,
            "field1": distance,
            "field2": ldr,
            "field3": moisture,
            "field4": temperature,
            "field5": ph,
        }
        requests.post(thingspeak_url, params=payload)
    except Exception as e:
        print(f"Error processing data: {e}")


def read_from_pic(ser):
    """Continuously reads data from the PIC."""
    global running
    while running:
        try:
            ser.write(b"D")  # Request data from PIC
            time.sleep(2)
            if ser.in_waiting > 0:
                line = ser.readline().decode("utf-8").strip()
                if line:
                    process_data(line)
        except Exception as e:
            print(f"Error reading from PIC: {e}")


def send_command(ser, command):
    """Sends a command to the PIC."""
    try:
        ser.write(command.encode())
        print(f"Sent command: {command}")
    except Exception as e:
        print(f"Error sending command: {e}")


def create_gui(ser):
    """Creates a GUI for controlling the PIC."""
    def on_exit():
        global running
        running = False
        root.destroy()

    def send_action(action):
        send_command(ser, action)

    root = tk.Tk()
    root.title("PIC Controller")

    arrow_frame = tk.Frame(root)
    arrow_frame.pack(pady=20)

    btn_up = tk.Button(arrow_frame, text="↑",
                       command=lambda: send_action("F"), width=5, height=2)
    btn_up.grid(row=0, column=1)

    btn_left = tk.Button(arrow_frame, text="←",
                         command=lambda: send_action("L"), width=5, height=2)
    btn_left.grid(row=1, column=0)

    btn_down = tk.Button(arrow_frame, text="↓",
                         command=lambda: send_action("B"), width=5, height=2)
    btn_down.grid(row=1, column=1)

    btn_right = tk.Button(arrow_frame, text="→",
                          command=lambda: send_action("R"), width=5, height=2)
    btn_right.grid(row=1, column=2)

    control_frame = tk.Frame(root)
    control_frame.pack(pady=10)

    btn_stepper = tk.Button(control_frame, text="Servo Motor",
                            command=lambda: send_action("S"), width=10)
    btn_stepper.grid(row=0, column=0, padx=5, pady=5)

    btn_led = tk.Button(control_frame, text="Turn LED On",
                        command=lambda: send_action("O"), width=10)
    btn_led.grid(row=0, column=1, padx=5, pady=5)

    btn_format = tk.Button(control_frame, text="Stop",
                           command=lambda: send_action("X"), width=10)
    btn_format.grid(row=1, column=0, padx=5, pady=5)

    btn_exit = tk.Button(control_frame, text="Exit", command=on_exit, width=10)
    btn_exit.grid(row=1, column=1, padx=5, pady=5)

    # Binding keys to actions for macOS compatibility
    def key_handler(event):
        keymap = {
            "Up": "F",
            "Left": "L",
            "Down": "B",
            "Right": "R",
            "s": "S",  # Servo Motor
            "o": "O",  # Turn LED On
            "x": "X",  # Stop
        }
        action = keymap.get(event.keysym)
        if action:
            send_action(action)

    root.bind("<KeyPress>", key_handler)

    # Start the GUI loop
    root.protocol("WM_DELETE_WINDOW", on_exit)
    root.mainloop()


def main():
    """Main function to handle the serial connection and GUI."""
    global running
    try:
        # Open serial connection with PIC
        ser = serial.Serial(serial_port, baud_rate, timeout=1)
        time.sleep(2)
        print(f"Connected to PIC on {serial_port}.")

        # Start a thread for continuously reading data
        read_thread = Thread(target=read_from_pic, args=(ser,))
        read_thread.start()

        create_gui(ser)

        read_thread.join()

    except serial.SerialException as e:
        print(f"Serial error: {e}")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if 'ser' in locals() and ser.is_open:
            send_command(ser, "X")
            ser.close()
        print("Serial connection closed.")


if __name__ == "__main__":
    main()
