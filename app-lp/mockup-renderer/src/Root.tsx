import React from "react";
import { Composition, Still } from "remotion";
import { MockupStill } from "./MockupStill";

const WIDTH = 720;
const HEIGHT = 1280;

export const RemotionRoot: React.FC = () => {
  return (
    <>
      <Still
        id="MockupHero"
        component={MockupStill}
        width={WIDTH}
        height={HEIGHT}
        defaultProps={{
          screenshotFile: "screenshot-01.png",
          bgGradient: ["#0EA5E9", "#38BDF8"] as [string, string],
        }}
      />
      <Still
        id="MockupFeature1"
        component={MockupStill}
        width={WIDTH}
        height={HEIGHT}
        defaultProps={{
          screenshotFile: "screenshot-01.png",
          bgGradient: ["#e8f4fd", "#d0e9f8"] as [string, string],
        }}
      />
      <Still
        id="MockupFeature2"
        component={MockupStill}
        width={WIDTH}
        height={HEIGHT}
        defaultProps={{
          screenshotFile: "screenshot-02.png",
          bgGradient: ["#e8f4fd", "#d0e9f8"] as [string, string],
        }}
      />
      <Still
        id="MockupFeature3"
        component={MockupStill}
        width={WIDTH}
        height={HEIGHT}
        defaultProps={{
          screenshotFile: "screenshot-03.png",
          bgGradient: ["#e8f4fd", "#d0e9f8"] as [string, string],
        }}
      />
    </>
  );
};
