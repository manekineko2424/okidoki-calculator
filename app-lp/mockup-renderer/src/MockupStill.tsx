import React from "react";
import { AbsoluteFill } from "remotion";
import { IPhoneFrame } from "./IPhoneFrame";

type MockupProps = {
  screenshotFile: string;
  bgGradient: [string, string];
};

export const MockupStill: React.FC<MockupProps> = ({
  screenshotFile,
  bgGradient,
}) => {
  // Output: 720 x 1280
  const phoneWidth = 720 * 0.75; // =540px, ~75% of canvas width

  return (
    <AbsoluteFill
      style={{
        background: `linear-gradient(160deg, ${bgGradient[0]}, ${bgGradient[1]})`,
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
      }}
    >
      <div
        style={{
          filter: "drop-shadow(0 20px 40px rgba(0,0,0,0.18))",
          marginTop: -20,
        }}
      >
        <IPhoneFrame screenshotFile={screenshotFile} width={phoneWidth} />
      </div>
    </AbsoluteFill>
  );
};
