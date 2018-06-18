package com.reactnativenavigation.viewcontrollers.stack;

import com.reactnativenavigation.parse.Options;
import com.reactnativenavigation.parse.params.Bool;
import com.reactnativenavigation.viewcontrollers.ViewController;

public class BackButtonHelper {
    public void addToChild(StackController stack, ViewController child) {
        if (stack.size() <= 1 || child.options.topBar.buttons.left != null || child.options.topBar.buttons.back.visible.isFalse()) return;
        Options options = new Options();
        options.topBar.buttons.back.visible = new Bool(true);
        child.mergeOptions(options);
    }
}