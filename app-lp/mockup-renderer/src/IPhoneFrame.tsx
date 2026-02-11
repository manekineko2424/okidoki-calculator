import React from "react";
import { Img, staticFile } from "remotion";

type Props = {
  screenshotFile: string;
  width: number;
};

export const IPhoneFrame: React.FC<Props> = ({ screenshotFile, width }) => {
  const bezel = Math.round(width * 0.028);
  const borderRadius = Math.round(width * 0.115);
  const screenRadius = borderRadius - bezel;
  const totalHeight = Math.round(width * (2622 / 1206) + bezel * 2);

  // Dynamic Island dimensions
  const diWidth = Math.round(width * 0.22);
  const diHeight = Math.round(diWidth * 0.3);
  const diTop = Math.round(bezel + width * 0.025);

  // Side button
  const btnWidth = Math.round(width * 0.008);
  const btnHeight = Math.round(width * 0.12);
  const btnTop = Math.round(totalHeight * 0.22);

  return (
    <div
      style={{
        position: "relative",
        width,
        height: totalHeight,
      }}
    >
      {/* Side button (power) */}
      <div
        style={{
          position: "absolute",
          right: -btnWidth,
          top: btnTop,
          width: btnWidth,
          height: btnHeight,
          backgroundColor: "#2a2a2a",
          borderRadius: `0 ${btnWidth}px ${btnWidth}px 0`,
        }}
      />

      {/* Volume buttons (left side) */}
      <div
        style={{
          position: "absolute",
          left: -btnWidth,
          top: btnTop - btnHeight * 0.2,
          width: btnWidth,
          height: btnHeight * 0.55,
          backgroundColor: "#2a2a2a",
          borderRadius: `${btnWidth}px 0 0 ${btnWidth}px`,
        }}
      />
      <div
        style={{
          position: "absolute",
          left: -btnWidth,
          top: btnTop + btnHeight * 0.5,
          width: btnWidth,
          height: btnHeight * 0.55,
          backgroundColor: "#2a2a2a",
          borderRadius: `${btnWidth}px 0 0 ${btnWidth}px`,
        }}
      />

      {/* Phone body */}
      <div
        style={{
          width: "100%",
          height: "100%",
          backgroundColor: "#1a1a1a",
          borderRadius,
          overflow: "hidden",
          position: "relative",
          boxShadow: "0 2px 20px rgba(0,0,0,0.15), inset 0 0 0 1px rgba(255,255,255,0.1)",
        }}
      >
        {/* Screen area */}
        <div
          style={{
            position: "absolute",
            top: bezel,
            left: bezel,
            right: bezel,
            bottom: bezel,
            borderRadius: screenRadius,
            overflow: "hidden",
            backgroundColor: "#000",
          }}
        >
          <Img
            src={staticFile(`screenshots/${screenshotFile}`)}
            style={{
              width: "100%",
              height: "100%",
              objectFit: "cover",
            }}
          />
        </div>

        {/* Dynamic Island */}
        <div
          style={{
            position: "absolute",
            top: diTop,
            left: "50%",
            transform: "translateX(-50%)",
            width: diWidth,
            height: diHeight,
            backgroundColor: "#000",
            borderRadius: diHeight / 2,
            zIndex: 2,
          }}
        />
      </div>
    </div>
  );
};
